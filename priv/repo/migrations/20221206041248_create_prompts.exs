defmodule Pict.Repo.Migrations.CreatePrompts do
  use Ecto.Migration

  def change do
    create table(:prompts) do
      add :game_id, references(:games, on_delete: :nothing)

      timestamps()
    end

    create index(:prompts, [:game_id])
  end
end
