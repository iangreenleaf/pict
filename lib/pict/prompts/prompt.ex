defmodule Pict.Prompts.Prompt do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pict.Games.Game
  alias Pict.Prompts.Submission

  schema "prompts" do

    belongs_to :game, Game
    #TODO ordering?
    has_many :submissions, Submission

    timestamps()
  end

  @doc false
  def changeset(prompt, attrs) do
    prompt
    |> cast(attrs, [])
  end
end
