defmodule Pict.Repo.Migrations.CreateGamePlayers do
  use Ecto.Migration

  def change do
    create table(:game_players) do
      add :order, :integer
      add :player_id, references(:accounts, on_delete: :nothing)
      add :game_id, references(:games, on_delete: :nothing)

      timestamps()
    end

    create index(:game_players, [:player_id])
    create index(:game_players, [:game_id])
  end
end
