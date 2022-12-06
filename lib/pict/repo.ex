defmodule Pict.Repo do
  use Ecto.Repo,
    otp_app: :pict,
    adapter: Ecto.Adapters.Postgres
end
