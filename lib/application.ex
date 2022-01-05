defmodule Keycloak.Application do
  use Application

  def start(_type, _args) do
    children = [
      Keycloak.Api.AdminApi.child_spec()
    ]

    opts = [strategy: :one_for_one, name: Keycloak.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
