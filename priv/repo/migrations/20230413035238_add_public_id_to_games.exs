defmodule Pict.Repo.Migrations.AddPublicIdToGames do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :public_id, :uuid
    end

    flush()

    for game <- Pict.Games.list_games() do
      Pict.Games.Game.changeset(game, %{})
      |> Ecto.Changeset.put_change(:public_id, Ecto.UUID.generate())
      |> Pict.Repo.update!()
    end

    create unique_index(:games, [:public_id])
  end
end
