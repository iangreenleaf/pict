defmodule Pict.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pict.Accounts.Account
  alias Pict.Games.GamePlayer
  alias Pict.Prompts.Prompt

  schema "games" do
    field :admin_id, Ecto.UUID, autogenerate: true
    field :name, :string
    field :state, Ecto.Enum, values: [:pending, :started]
    belongs_to :owner, Account
    has_many :game_players, GamePlayer, on_replace: :delete_if_exists
    has_many :players, through: [:game_players, :player]
    has_many :prompts, Prompt

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
