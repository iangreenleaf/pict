defmodule Pict.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :email, :string

      timestamps()
    end
  end
end
