defmodule Pict.Games.Signup do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :email, :string
    field :player_emails, :string
  end

  @doc false
  def changeset(form, attrs) do
    form
    |> cast(attrs, [:name, :email, :player_emails])
    |> validate_required([:name, :email, :player_emails])
  end
end
