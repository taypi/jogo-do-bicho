defmodule JogoDoBicho.Repo do
  use Ecto.Repo,
    otp_app: :jogo_do_bicho,
    adapter: Ecto.Adapters.Postgres
end
