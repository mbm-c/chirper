defmodule Chirper.Repo do
  use Ecto.Repo,
    otp_app: :chirper,
    adapter: Ecto.Adapters.Postgres
end
