defmodule Pict.Repo.Migrations.AddDrawingToSubmissions do
  use Ecto.Migration

  def change do
    alter table("submissions") do
      add :drawing, :string
    end
  end
end
