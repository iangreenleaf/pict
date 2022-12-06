defmodule Pict.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :admin_id, :uuid
      add :name, :string
      add :owner_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:games, [:admin_id])
    create index(:games, [:owner_id])
  end
end
