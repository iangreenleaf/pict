defmodule Pict.Repo.Migrations.AddNameToGamePlayers do
  use Ecto.Migration

  def change do
    alter table("game_players") do
      add :name, :string
    end
  end
end
