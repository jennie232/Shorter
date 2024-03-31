defmodule Shorter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ShorterWeb.Telemetry,
      Shorter.Repo,
      {DNSCluster, query: Application.get_env(:shorter, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Shorter.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Shorter.Finch},
      # Start a worker by calling: Shorter.Worker.start_link(arg)
      # {Shorter.Worker, arg},
      # Start to serve requests, typically the last entry
      ShorterWeb.Endpoint,
      {Cachex, name: :slug_cache}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Shorter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ShorterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
