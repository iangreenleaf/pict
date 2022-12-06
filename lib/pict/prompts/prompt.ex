defmodule Pict.Prompts.Prompt do
  use Ecto.Schema
  import Ecto.Changeset

  schema "prompts" do

    field :game, :id

    timestamps()
  end

  @doc false
  def changeset(prompt, attrs) do
    prompt
    |> cast(attrs, [])
    |> validate_required([])
  end
end
