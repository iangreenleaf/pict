defmodule Pict.Repo.Migrations.AddStateToGames do
  use Ecto.Migration

  def change do
    alter table("games") do
      add :state, :string, default: "pending"
    end
  end
end
