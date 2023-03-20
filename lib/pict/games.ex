defmodule Pict.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Pict.Repo

  alias Pict.Accounts
  alias Pict.Prompts
  alias Pict.Prompts.Prompt
  alias Pict.Games.Game
  alias Pict.Games.GamePlayer
  alias Pict.Games.Signup
  alias Pict.Games.PlayerRegistration

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)
  def get_game_admin!(admin_id), do: Repo.get_by!(Game, admin_id: admin_id)

  def get_game_for_admin(admin_id) do
    prompts_query = from(
      p in Prompt,
      join: player in assoc(p, :owner),
      order_by: player.order
    )

    from(
      g in Game,
      where: g.admin_id == ^admin_id,
      preload: [
        game_players: [:player],
        prompts: ^{prompts_query, [submissions: [game_player: [:player]]]}
      ]
    )
    |> Repo.one()
  end

  def submission_stats(%Game{ prompts: prompts }) do
    remaining = Enum.map(prompts, &Prompts.submissions_remaining/1)
    %{
      max_remaining: Enum.max(remaining),
      median_remaining: Math.Enum.median(remaining),
    }
  end

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def register_players!(game, attrs = %PlayerRegistration{}) do
    game =
      game
      |> Repo.preload(:game_players)
      |> Game.changeset(%{})
      |> put_assoc(:game_players, game_players(attrs.player_emails))
      |> Repo.update!()

    game
  end

  def start!(game) do
    game = game |> Repo.preload([:game_players, :owner])

    Prompts.initialize_prompts!(game)

    game
      |> Game.changeset(%{})
      |> put_change(:state, :started)
      |> Repo.update!()
  end

  def create_game_from_signup!(attrs = %Signup{}) do
    game =
      %Game{}
      |> Game.changeset(%{name: attrs.name})
      |> put_assoc(:owner, Accounts.find_or_initialize(attrs.email))
      |> Repo.insert!()

    send_admin_email(game)

    game
  end

  defp send_admin_email(game) do
    PictWeb.Emails.UserEmail.game_ready(game)
    |> Pict.Mailer.deliver()
  end

  defp game_players(emails) do
    emails
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Stream.map(&Accounts.find_or_initialize/1)
    |> Stream.with_index
    |> Stream.map(fn {account, idx} -> %GamePlayer{ order: idx , player: account } end)
    |> Enum.to_list()
  end

  def create_signup(attrs) do
    %Signup{}
    |> Signup.changeset(attrs)
    |> apply_action(:create)
  end

  def create_player_registration(attrs) do
    %PlayerRegistration{}
    |> PlayerRegistration.changeset(attrs)
    |> apply_action(:create)
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  def change_player_registration(%Game{} = game, attrs \\ %{}) do
    PlayerRegistration.changeset(%PlayerRegistration{}, attrs)
  end

  def change_signup(_game) do
    # doesn't support editing right now
    Signup.changeset(%Signup{}, %{})
  end

  alias Pict.Games.GamePlayer

  @doc """
  Returns the list of game_players.

  ## Examples

      iex> list_game_players()
      [%GamePlayer{}, ...]

  """
  def list_game_players do
    Repo.all(GamePlayer)
  end

  @doc """
  Gets a single game_player.

  Raises `Ecto.NoResultsError` if the Game player does not exist.

  ## Examples

      iex> get_game_player!(123)
      %GamePlayer{}

      iex> get_game_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game_player!(id), do: Repo.get!(GamePlayer, id)

  @doc """
  Creates a game_player.

  ## Examples

      iex> create_game_player(%{field: value})
      {:ok, %GamePlayer{}}

      iex> create_game_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game_player(attrs \\ %{}) do
    %GamePlayer{}
    |> GamePlayer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game_player.

  ## Examples

      iex> update_game_player(game_player, %{field: new_value})
      {:ok, %GamePlayer{}}

      iex> update_game_player(game_player, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game_player(%GamePlayer{} = game_player, attrs) do
    game_player
    |> GamePlayer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a game_player.

  ## Examples

      iex> delete_game_player(game_player)
      {:ok, %GamePlayer{}}

      iex> delete_game_player(game_player)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game_player(%GamePlayer{} = game_player) do
    Repo.delete(game_player)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game_player changes.

  ## Examples

      iex> change_game_player(game_player)
      %Ecto.Changeset{data: %GamePlayer{}}

  """
  def change_game_player(%GamePlayer{} = game_player, attrs \\ %{}) do
    GamePlayer.changeset(game_player, attrs)
  end
end
