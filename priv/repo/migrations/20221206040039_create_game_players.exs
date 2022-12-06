defmodule Pict.Repo.Migrations.CreateGamePlayers do
  use Ecto.Migration

  def change do
    create table(:game_players) do
      add :order, :integer
      add :player, references(:accounts, on_delete: :nothing)
      add :game, references(:games, on_delete: :nothing)

      timestamps()
    end

    create index(:game_players, [:player])
    create index(:game_players, [:game])
  end
end
