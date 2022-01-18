defmodule KeycloakEx.Api.AdminApi do

  # alias Finch.Response

  # @spec child_spec :: {Finch, [{:name, Keycloak.Api.AdminApi} | {:pools, map}, ...]}
  # def child_spec do
  #   host_uri = Application.get_env(:keycloak, :host_uri)

  #   {
  #     Finch,
  #     name: __MODULE__,
  #     pools: %{
  #       :default => [size: 10],
  #       "#{host_uri}" => [size: 32, count: 8]
  #     }
  #   }
  # end

  # defp response({:ok, resp}), do: Jason.decode!(resp.body)
  # defp response(resp), do: resp

  # def get_request(url, body \\ nil) do
  #   host_uri = Application.get_env(:keycloak, :host_uri)
  #   admin = Application.get_env(:keycloak, Keycloak.Clients.Admin)

  #   :get
  #   |> Finch.build(
  #       "#{host_uri}/auth/admin/realms/#{admin[:realm]}/#{url}",
  #       [
  #         {"Authorization", "Bearer #{Keycloak.Clients.Admin.get_token().token.access_token}"},
  #         {"Accept", "application/json"}
  #       ],
  #       body
  #     )
  #   |> Finch.request(__MODULE__)
  #   |> response
  # end

  # def get_users() do
  #   get_request("users")
  #   |> IO.inspect
  # end

  # def get_user(id) do
  #   get_request("users/#{id}")
  #   |> IO.inspect
  # end
end
