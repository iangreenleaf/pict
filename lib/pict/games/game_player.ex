defmodule Pict.Games.GamePlayer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pict.Accounts.Account
  alias Pict.Games.Game
  alias Pict.Prompts.Submission

  schema "game_players" do
    field :order, :integer
    field :name, :string
    belongs_to :player, Account
    belongs_to :game, Game
    has_many :submissions, Submission

    timestamps()
  end

  @doc false
  def changeset(game_player, attrs) do
    game_player
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
