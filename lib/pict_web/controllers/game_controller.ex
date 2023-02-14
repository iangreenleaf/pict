defmodule PictWeb.GameController do
  use PictWeb, :controller

  alias Pict.Repo
  alias Pict.Games
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
    case Games.get_game_admin!(admin_id) do
      %{state: :pending} ->
        redirect(conn, to: ~p"/games/#{admin_id}/confirm")

      game ->
        game = Repo.preload(game, [prompts: [submissions: [game_player: [:player]]]])
        render(conn, "show.html", game: game)
    end
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
