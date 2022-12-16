defmodule Pict.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pict.Accounts.Account
  alias Pict.Games.GamePlayer

  schema "games" do
    field :admin_id, Ecto.UUID, autogenerate: true
    field :name, :string
    belongs_to :owner, Account
    has_many :game_players, GamePlayer
    has_many :players, through: [:game_players, :players]

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:admin_id)
  end
end
