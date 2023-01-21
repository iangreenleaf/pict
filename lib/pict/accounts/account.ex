defmodule Pict.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Swoosh.Email.Recipient, address: :email}

  schema "accounts" do
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end
end
