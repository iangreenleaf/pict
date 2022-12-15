defmodule Pict.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pict.Accounts.Account

  schema "games" do
    field :admin_id, Ecto.UUID, autogenerate: true
    field :name, :string
    belongs_to :owner, Account

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
