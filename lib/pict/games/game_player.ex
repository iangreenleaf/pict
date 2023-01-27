defmodule Pict.Games.GamePlayer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pict.Accounts.Account
  alias Pict.Games.Game

  schema "game_players" do
    field :order, :integer
    field :name, :string
    belongs_to :player, Account
    belongs_to :game, Game

    timestamps()
  end

  @doc false
  def changeset(game_player, attrs) do
    game_player
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
