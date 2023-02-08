defmodule Pict.Games.Signup do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :email, :string
  end

  @doc false
  def changeset(form, attrs) do
    form
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
