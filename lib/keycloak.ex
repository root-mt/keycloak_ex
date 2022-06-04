defmodule KeycloakEx do
  @moduledoc """
  A Keycloak client with focus on ease of use. From keycloak:18 there where some updates to the host_uri,
  this plugin was update to remove /auth from the uri by default. **So if you are utilising an older version of
  Keycloak its importat to add "/auth" as part of the host_uri ex:  host_uri: "http://localhost:8081/auth"**

  #Usage

  KeycloakEx is split in 4:

    * `KeycloakEx.Client.User` - User Client to easily redirect and handle oAuth2.0 tokens
    * `KeycloakEx.Client.Admin` - Admin Client to easily connect with keycload admin REST API
    * `KeycloakEx.VerifyBearerToken` - Plug to receive bearer token an verify valid
    * `KeycloakEx.VerifySessionToken` = Plug to manage token part of elixir

  # User Client

  To create a User Client. Configure it through the following list:

      config :test_app, TestApp.KeycloakClient,
        realm: "test_app",
        client_id: "testapp-portal",
        site: "http://localhost:4000",
        scope: "testapp_scope",
        host_uri: "http://localhost:8081"

  Create module with the user client code

      defmodule TestApp.KeycloakClient do
          use KeycloakEx.Client.User,
            otp_app: :test_app
      end

  # Admin Client

  To create an Admin Client. Configure it through the following list:

      config :test_app, TestApp.KeycloakAdmin,
          realm: "master",
          username: "admin",
          password: "test123!",
          client_id: "admin-cli",
          client_secret: "83bf8d8e-e608-477b-b812-48b9ac4aa43a",
          host_uri: "http://localhost:8081"

  Create module with the admin client code

      defmodule TestApp.KeycloakAdmin do
          use KeycloakEx.Client.Admin,
            otp_app: :test_app
      end

  # Plugs

  keycloak_ex has 2 different plugs which can be used in different scenarions.

  ## Verify Authorization Bearer Access Token

  In the case when the access token is handled by a third party such as the front-end. Utilise the VerifyBearerToken,
  the plug would check the token and introspect the values of it and redirect if incorret.


      plug KeycloakEx.VerifyBearerToken, client: TestApp.KeycloakClient

  ## Manage token from the backend.

  In the case where the access token is managed by the backend in the plug session, utilise the VerifySessionToken.

      plug KeycloakEx.VerifySessionToken, client: TestApp.KeycloakClient

  Its important to also handle the call back when handling the access token from the backend. For this add the
  following route in the phoenix router.ex.

      get "/login_cb", UserController, :login_redirect

  In the controller its important to get the token from the code passed in the call back

      defmodule TestApp.UserController do
        use TestAppWeb, :controller

        def login_redirect(conn, params) do
          token =
            TestApp.KeycloakClient.get_token!(code: params["code"])

          conn
          |> put_session(:token, token.token)
          |> redirect(to: "/")
          |> halt()
        end
      end

  """

  @doc """
  Hello world.

  ## Examples

      iex> Keycloak.hello()
      :world

  """
end
