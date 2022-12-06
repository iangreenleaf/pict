defmodule Pict.Games.GamePlayer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "game_players" do
    field :order, :integer
    field :player, :id
    field :game, :id

    timestamps()
  end

  @doc false
  def changeset(game_player, attrs) do
    game_player
    |> cast(attrs, [:order])
    |> validate_required([:order])
  end
end
