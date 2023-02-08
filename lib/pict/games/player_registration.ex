defmodule Pict.Games.PlayerRegistration do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :player_emails, :string
  end

  @doc false
  def changeset(form, attrs) do
    form
    |> cast(attrs, [:player_emails])
    |> validate_required([:player_emails])
  end
end
