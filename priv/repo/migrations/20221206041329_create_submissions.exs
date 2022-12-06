defmodule Pict.Repo.Migrations.CreateSubmissions do
  use Ecto.Migration

  def change do
    create table(:submissions) do
      add :order, :integer
      add :completed, :boolean, default: false, null: false
      add :text, :string
      add :prompt, references(:prompts, on_delete: :nothing)
      add :player, references(:game_players, on_delete: :nothing)

      timestamps()
    end

    create index(:submissions, [:prompt])
    create index(:submissions, [:player])
  end
end
