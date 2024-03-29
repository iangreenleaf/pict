defmodule Pict.Prompts do
  @moduledoc """
  The Prompts context.
  """

  require Integer

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Pict.Repo

  alias Pict.Games
  alias Pict.Prompts.Prompt
  alias Pict.Prompts.Submission

  def expects_drawing?(%{order: order}) do
    Integer.is_odd(order)
  end

  def first_submission?(%Submission{order: 0}), do: true
  def first_submission?(_), do: false

  def initialize_prompts!(game) do
    prompts = for l <- 1..length(game.game_players) do
      {b, a} = Enum.split(game.game_players, l)
      create_prompt!(game: game, game_players: a ++ b)
    end

    send_invites(prompts, game.owner)

    prompts
  end

  defp send_invites(prompts, owner) do
    for submission <- first_submissions(prompts) do
      PictWeb.Emails.UserEmail.prompt_ready(submission, owner)
      |> Pict.Mailer.deliver()
    end
  end

  defp first_submissions(prompts) do
    import Ecto.Query, only: [from: 2]

    prompt_ids = for p <- prompts, do: p.id

    Repo.all(
      from s in Submission,
      where: s.order == 0 and s.prompt_id in ^prompt_ids,
      preload: [:player]
    )
  end

  defp create_prompt!(game: game, game_players: players) do
    submissions =
      players
      |> Enum.with_index
      |> Enum.map(fn {player, idx} ->
        %Submission{}
        |> Submission.changeset(%{order: idx})
        |> put_assoc(:game_player, player)
      end)

    %Prompt{}
    |> Prompt.changeset(%{})
    |> put_assoc(:owner, List.first(players))
    |> put_assoc(:submissions, submissions)
    |> put_assoc(:game, game)
    |> Repo.insert!()
  end

  def get_clue_for(%Submission{prompt_id: prompt_id, order: order}) do
    get_submission_at(prompt_id, order - 1)
  end

  def activate_next_submission(%Submission{prompt_id: prompt_id, order: order}) do
    case get_submission_at(prompt_id, order + 1) do
      nil -> false
      next_sub ->
        %{starter_name: starter_name, total: total} = get_submission_name_details(next_sub)
        PictWeb.Emails.UserEmail.submission_ready(%{
          submission: Repo.preload(next_sub, [:player]),
          starter_name: starter_name,
          total: total
        })
        |> Pict.Mailer.deliver()
    end
  end

  def submissions_remaining(%Prompt{ submissions: submissions }) do
    Enum.count(submissions, fn s -> !s.completed end)
  end

  def get_submission_at(prompt_id, order) do
    Repo.get_by(
      Submission,
      prompt_id: prompt_id,
      order: order
    )
  end

  def get_submission_name_details(%Submission{id: id, game_player_id: game_player_id}) do
    from(
      s in Submission,
      join: prompt in assoc(s, :prompt),
      join: starter in assoc(prompt, :owner),
      join: all_submissions in Submission,
      on: all_submissions.prompt_id == s.prompt_id,
      where: s.id == ^id,
      select: %{starter_name: starter.name, total: count(all_submissions.id)},
      group_by: [s.id, starter.id]
    )
    |> Repo.one()
  end

  def get_prompts_for_download(game_admin_id) do
    from(
      p in Prompt,
      distinct: p.id,
      join: submissions in assoc(p, :submissions),
      join: game in assoc(p, :game),
      where: game.admin_id == ^game_admin_id,
      preload: [:submissions, :game, :owner]
    )
    |> Repo.all()
  end

  def get_first_unfinished_for_admin(game_admin_id, prompt_id) do
    from(
      s in Submission,
      join: p in assoc(s, :prompt),
      join: _g in assoc(p, :game),
      where: s.completed == false and p.id == ^prompt_id,
      order_by: s.order,
      limit: 1,
      preload: [:player, prompt: [:submissions]]
    )
    |> Repo.one()
  end

  def other_undone_submissions(%Submission{id: id, game_player_id: game_player_id}) do
    from(
      s in Submission,
      join: prev in Submission,
      on: prev.prompt_id == s.prompt_id and prev.order == s.order - 1,
      join: prompt in assoc(s, :prompt),
      join: starter in assoc(prompt, :owner),
      join: all_submissions in Submission,
      on: all_submissions.prompt_id == s.prompt_id,
      where: s.id != ^id and s.game_player_id == ^game_player_id,
      where: prev.completed == true and s.completed == false,
      select: %{id: s.id, order: s.order, starter_name: starter.name, total: count(all_submissions.id)},
      order_by: s.order,
      group_by: [s.id, starter.id],
      limit: 3
    )
    |> Repo.all()
  end

  def send_reminder(submission) do
    %{starter_name: starter_name, total: total} = get_submission_name_details(submission)

    PictWeb.Emails.UserEmail.submission_reminder(%{
      submission: submission,
      starter_name: starter_name,
      total: total
    })
    |> Pict.Mailer.deliver()
  end

  @doc """
  Returns the list of prompts.

  ## Examples

      iex> list_prompts()
      [%Prompt{}, ...]

  """
  def list_prompts do
    Repo.all(Prompt)
  end

  @doc """
  Gets a single prompt.

  Raises `Ecto.NoResultsError` if the Prompt does not exist.

  ## Examples

      iex> get_prompt!(123)
      %Prompt{}

      iex> get_prompt!(456)
      ** (Ecto.NoResultsError)

  """
  def get_prompt!(id), do: Repo.get!(Prompt, id)

  @doc """
  Creates a prompt.

  ## Examples

      iex> create_prompt(%{field: value})
      {:ok, %Prompt{}}

      iex> create_prompt(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_prompt(attrs \\ %{}) do
    %Prompt{}
    |> Prompt.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a prompt.

  ## Examples

      iex> update_prompt(prompt, %{field: new_value})
      {:ok, %Prompt{}}

      iex> update_prompt(prompt, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_prompt(%Prompt{} = prompt, attrs) do
    prompt
    |> Prompt.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a prompt.

  ## Examples

      iex> delete_prompt(prompt)
      {:ok, %Prompt{}}

      iex> delete_prompt(prompt)
      {:error, %Ecto.Changeset{}}

  """
  def delete_prompt(%Prompt{} = prompt) do
    Repo.delete(prompt)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking prompt changes.

  ## Examples

      iex> change_prompt(prompt)
      %Ecto.Changeset{data: %Prompt{}}

  """
  def change_prompt(%Prompt{} = prompt, attrs \\ %{}) do
    Prompt.changeset(prompt, attrs)
  end

  alias Pict.Prompts.Submission

  @doc """
  Returns the list of submissions.

  ## Examples

      iex> list_submissions()
      [%Submission{}, ...]

  """
  def list_submissions do
    Repo.all(Submission)
  end

  @doc """
  Gets a single submission.

  Raises `Ecto.NoResultsError` if the Submission does not exist.

  ## Examples

      iex> get_submission!(123)
      %Submission{}

      iex> get_submission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_submission!(id), do: Repo.get!(Submission, id) |> Repo.preload(:game_player)

  @doc """
  Creates a submission.

  ## Examples

      iex> create_submission(%{field: value})
      {:ok, %Submission{}}

      iex> create_submission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_submission(attrs \\ %{}) do
    %Submission{}
    |> Submission.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a submission.

  ## Examples

      iex> update_submission(submission, %{field: new_value})
      {:ok, %Submission{}}

      iex> update_submission(submission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_submission(%Submission{} = submission, attrs) do
    submission
    |> Submission.changeset(attrs)
    |> put_change(:completed, true)
    |> Repo.update()
    |> case do
      {:ok, submission} ->
        activate_next_submission(submission)
        {:ok, submission}

      err -> err
    end
  end

  @doc """
  Deletes a submission.

  ## Examples

      iex> delete_submission(submission)
      {:ok, %Submission{}}

      iex> delete_submission(submission)
      {:error, %Ecto.Changeset{}}

  """
  def delete_submission(%Submission{} = submission) do
    Repo.delete(submission)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking submission changes.

  ## Examples

      iex> change_submission(submission)
      %Ecto.Changeset{data: %Submission{}}

  """
  def change_submission(%Submission{} = submission, attrs \\ %{}) do
    Submission.changeset(submission, attrs)
  end
end
