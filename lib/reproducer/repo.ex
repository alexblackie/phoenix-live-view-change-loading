defmodule Reproducer.Repo do
  use Ecto.Repo,
    otp_app: :reproducer,
    adapter: Ecto.Adapters.Postgres
end
