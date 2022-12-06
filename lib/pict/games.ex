defmodule Pict.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias Pict.Repo

  alias Pict.Games.Game

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

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
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
