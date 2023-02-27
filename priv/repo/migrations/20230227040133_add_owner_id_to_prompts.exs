defmodule Pict.Repo.Migrations.AddOwnerIdToPrompts do
  use Ecto.Migration
  import Ecto.Query, only: [from: 2]
  alias Pict.Repo

  def up do
    alter table("prompts") do
      add :owner_id, references(:game_players, on_delete: :nilify_all)
    end

    flush()

    from(
      p in "prompts",
      join: s in "submissions",
      on: [prompt_id: p.id, order: 0],
      update: [set: [owner_id: s.game_player_id]]
    )
    |> Repo.update_all([])
  end

  def down do
    alter table("prompts") do
      remove :owner_id
    end
  end
end
