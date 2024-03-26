defmodule Shorter.Repo do
  use Ecto.Repo,
    otp_app: :shorter,
    adapter: Ecto.Adapters.Postgres
end
