defmodule Pict.Repo.Migrations.CreatePrompts do
  use Ecto.Migration

  def change do
    create table(:prompts) do
      add :game, references(:games, on_delete: :nothing)

      timestamps()
    end

    create index(:prompts, [:game])
  end
end
