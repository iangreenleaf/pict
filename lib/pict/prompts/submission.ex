defmodule Pict.Prompts.Submission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "submissions" do
    field :completed, :boolean, default: false
    field :order, :integer
    field :text, :string
    field :prompt, :id
    field :player, :id

    timestamps()
  end

  @doc false
  def changeset(submission, attrs) do
    submission
    |> cast(attrs, [:order, :completed, :text])
    |> validate_required([:order, :completed, :text])
  end
end
