defmodule Pict.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :admin_id, Ecto.UUID
    field :name, :string
    field :owner_id, :id

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:admin_id, :name])
    |> validate_required([:admin_id, :name])
    |> unique_constraint(:admin_id)
  end
end
