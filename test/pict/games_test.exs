defmodule Pict.GamesTest do
  use Pict.DataCase

  alias Pict.Games

  describe "games" do
    alias Pict.Games.Game

    import Pict.GamesFixtures

    @invalid_attrs %{admin_id: nil, name: nil}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Games.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Games.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{admin_id: "7488a646-e31f-11e4-aace-600308960662", name: "some name"}

      assert {:ok, %Game{} = game} = Games.create_game(valid_attrs)
      assert game.admin_id == "7488a646-e31f-11e4-aace-600308960662"
      assert game.name == "some name"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      update_attrs = %{admin_id: "7488a646-e31f-11e4-aace-600308960668", name: "some updated name"}

      assert {:ok, %Game{} = game} = Games.update_game(game, update_attrs)
      assert game.admin_id == "7488a646-e31f-11e4-aace-600308960668"
      assert game.name == "some updated name"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_game(game, @invalid_attrs)
      assert game == Games.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Games.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Games.change_game(game)
    end
  end

  describe "game_players" do
    alias Pict.Games.GamePlayer

    import Pict.GamesFixtures

    @invalid_attrs %{order: nil}

    test "list_game_players/0 returns all game_players" do
      game_player = game_player_fixture()
      assert Games.list_game_players() == [game_player]
    end

    test "get_game_player!/1 returns the game_player with given id" do
      game_player = game_player_fixture()
      assert Games.get_game_player!(game_player.id) == game_player
    end

    test "create_game_player/1 with valid data creates a game_player" do
      valid_attrs = %{order: 42}

      assert {:ok, %GamePlayer{} = game_player} = Games.create_game_player(valid_attrs)
      assert game_player.order == 42
    end

    test "create_game_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game_player(@invalid_attrs)
    end

    test "update_game_player/2 with valid data updates the game_player" do
      game_player = game_player_fixture()
      update_attrs = %{order: 43}

      assert {:ok, %GamePlayer{} = game_player} = Games.update_game_player(game_player, update_attrs)
      assert game_player.order == 43
    end

    test "update_game_player/2 with invalid data returns error changeset" do
      game_player = game_player_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_game_player(game_player, @invalid_attrs)
      assert game_player == Games.get_game_player!(game_player.id)
    end

    test "delete_game_player/1 deletes the game_player" do
      game_player = game_player_fixture()
      assert {:ok, %GamePlayer{}} = Games.delete_game_player(game_player)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game_player!(game_player.id) end
    end

    test "change_game_player/1 returns a game_player changeset" do
      game_player = game_player_fixture()
      assert %Ecto.Changeset{} = Games.change_game_player(game_player)
    end
  end
end
