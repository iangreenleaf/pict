defmodule Pict.Games.GamePlayer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pict.Accounts.Account
  alias Pict.Games.Game

  schema "game_players" do
    field :order, :integer
    belongs_to :player, Account
    belongs_to :game, Game

    timestamps()
  end

  @doc false
  def changeset(game_player, attrs) do
    game_player
    |> cast(attrs, [:order])
    |> validate_required([:order])
  end
end
