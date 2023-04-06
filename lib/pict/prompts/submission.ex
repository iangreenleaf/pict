defmodule Pict.Prompts.Submission do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset
  alias Pict.Games.GamePlayer
  alias Pict.Prompts.Prompt

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "submissions" do
    field :completed, :boolean, default: false
    field :order, :integer
    field :text, :string
    field :drawing, Pict.Drawing.Type
    belongs_to :prompt, Prompt
    has_one :game, through: [:prompt, :game]
    belongs_to :game_player, GamePlayer
    has_one :player, through: [:game_player, :player]

    timestamps()
  end

  @doc false
  def changeset(submission, attrs) do
    submission
    |> cast(attrs, [:order, :text])
    |> cast_attachments(attrs, [:drawing])
    |> validate_required([:order])
  end
end
