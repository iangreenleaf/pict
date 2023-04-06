defmodule PictWeb.GameController do
  use PictWeb, :controller

  alias Pict.Repo
  alias Pict.Games
  alias Pict.Prompts
  alias Pict.Games.Game

  def index(conn, _params) do
    games = Games.list_games()
    render(conn, "index.html", games: games)
  end

  def new(conn, _params) do
    changeset = Games.change_signup(%Game{})
    render(conn, "new.html", changeset: changeset)
  end

  def confirm(conn, %{"admin_id" => admin_id}) do
    game = Games.get_game_admin!(admin_id)
    changeset = Games.change_player_registration(game)
    render(conn, "confirm.html", changeset: changeset, game: game)
  end

  def create(conn, %{"signup" => params}) do
    case Games.create_signup(params) do
      {:ok, signup} ->
        game = Games.create_game_from_signup!(signup)
        conn
        |> redirect(to: ~p"/games/pending")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def admin(conn, %{"admin_id" => admin_id}) do
    case Games.get_game_for_admin(admin_id) do
      %{state: :pending} ->
        redirect(conn, to: ~p"/games/#{admin_id}/confirm")

      game ->
        player_index = (for p <- game.game_players, do: p.id) |> Enum.with_index() |> Enum.into(%{})
        render(
          conn,
          "show.html",
          game: game,
          player_index: player_index,
          submission_stats: Games.submission_stats(game)
        )
    end
  end

  def download(conn, %{"admin_id" => admin_id}) do
    case Games.get_game_for_admin(admin_id) do
      game ->
        {:ok, path} = Briefly.create()
        {:ok, zip_path} = :zip.create(path, files_for_download(game))

        filename = String.replace(game.name, ~r/[^[:word:] ]/, "") <> ".zip"
        send_download(conn, {:file, zip_path}, filename: filename, encode: false)
    end
  end

  defp files_for_download(game) do
    Prompts.get_prompts_for_download(game.admin_id)
    |> Enum.flat_map(&submissions_for_download/1)
  end

  defp submissions_for_download(prompt) do
      prompt_complete = Enum.all?(prompt.submissions, fn s -> s.completed end)
      owner = prompt.owner
      prompt_name = if prompt_complete, do: owner.name, else: "#{owner.name} (Incomplete)"
      for submission <- prompt.submissions, submission.completed do
        zip_file_entry(submission, Path.join(prompt_name, "#{owner.name} #{submission.order}"))
      end
  end

  defp zip_file_entry(submission = %{drawing: nil, text: text}, basename) do
    {to_charlist(basename <> ".txt"), text}
  end

  defp zip_file_entry(submission = %{drawing: drawing}, basename) do
    dir = Application.fetch_env!(:pict, :uploads_path)
    filename = Waffle.Definition.Versioning.resolve_file_name(
      Pict.Drawing, :original, {drawing, submission}
    )
    case File.read(Path.expand(filename, dir)) do
      {:ok, data} ->
        {to_charlist(basename <> Path.extname(filename)), data}
    end
  end

  def reminder(conn, %{"admin_id" => admin_id, "prompt_id" => prompt_id}) do
    case Prompts.get_first_unfinished_for_admin(admin_id, prompt_id) do
      nil ->
        conn

      submission ->
        Prompts.send_reminder(submission)
        conn
        |> put_flash(:info, "Reminder sent.")
    end
    |> redirect(to: ~p"/games/#{admin_id}")
  end

  def start(conn, %{"admin_id" => admin_id, "player_registration" => params}) do
    game = Games.get_game_admin!(admin_id)

    case Games.create_player_registration(params) do
      {:ok, registration} ->
        game = Games.register_players!(game, registration) |> Games.start!()
        conn
        |> put_flash(:info, "Game created successfully.")
        |> redirect(to: ~p"/games/#{game.admin_id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "confirm.html", changeset: changeset)
    end
  end

  def pending(conn, _params) do
    render(conn, "pending.html")
  end

  def edit(conn, %{"id" => id}) do
    game = Games.get_game!(id)
    changeset = Games.change_game(game)
    render(conn, "edit.html", game: game, changeset: changeset)
  end
end
