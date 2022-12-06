defmodule Pict.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pict.Games` context.
  """

  @doc """
  Generate a unique game admin_id.
  """
  def unique_game_admin_id do
    raise "implement the logic to generate a unique game admin_id"
  end

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        admin_id: unique_game_admin_id(),
        name: "some name"
      })
      |> Pict.Games.create_game()

    game
  end
end
