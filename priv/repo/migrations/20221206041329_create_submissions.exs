defmodule Pict.Repo.Migrations.CreateSubmissions do
  use Ecto.Migration

  def change do
    create table(:submissions, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :order, :integer
      add :completed, :boolean, default: false, null: false
      add :text, :string
      add :prompt_id, references(:prompts, on_delete: :delete_all)
      add :game_player_id, references(:game_players, on_delete: :nilify_all)

      timestamps()
    end

    create index(:submissions, [:prompt_id])
    create index(:submissions, [:game_player_id])
  end
end
