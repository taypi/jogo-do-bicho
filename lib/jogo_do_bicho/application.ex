defmodule JogoDoBicho.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      JogoDoBichoWeb.Telemetry,
      JogoDoBicho.Repo,
      {DNSCluster, query: Application.get_env(:jogo_do_bicho, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: JogoDoBicho.PubSub},
      # Start a worker by calling: JogoDoBicho.Worker.start_link(arg)
      # {JogoDoBicho.Worker, arg},
      # Start to serve requests, typically the last entry
      JogoDoBichoWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: JogoDoBicho.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JogoDoBichoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
