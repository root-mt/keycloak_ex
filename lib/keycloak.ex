defmodule KeycloakEx do
  @moduledoc """
  A Keycloak client with focus on ease of use. KeycloakEx is still in alpha.

  #Usage

  KeycloakEx is split in 4:

    * `KeycloakEx.Client.User` - User Client to easily redirect and handle oAuth2.0 tokens
    * `KeycloakEx.Client.Admin` - Admin Client to easily connect with keycload admin REST API
    * `KeycloakEx.VerifyBearerToken` - Plug to receive bearer token an verify valid
    * `KeycloakEx.VerifySessionToken` = Plug to manage token part of elixir

  # User Client

  To create a User Client

      config :test_app, TestApp.KeycloakClient,
        realm: "test_app",
        client_id: "testapp-portal",
        site: "http://localhost:4000",
        scope: "testapp_scope",
        host_uri: "http://localhost:8081"


      defmodule TestApp.KeycloakClient do
          use KeycloakEx.Client.User,
            otp_app: :test_app
      end

  # Admin Client

  To create an Admin Client

      config :test_app, TestApp.KeycloakAdmin,
          realm: "master",
          username: "admin",
          password: "test123!",
          client_id: "admin-cli",
          client_secret: "83bf8d8e-e608-477b-b812-48b9ac4aa43a",
          host_uri: "http://localhost:8081"


      defmodule TestApp.KeycloakAdmin do
          use KeycloakEx.Client.Admin,
            otp_app: :test_app
      end

  # Plugs

  To use plug in the router add:

      plug KeycloakEx.VerifySessionToken, client: TestApp.KeycloakClient

  """

  @doc """
  Hello world.

  ## Examples

      iex> Keycloak.hello()
      :world

  """
end
