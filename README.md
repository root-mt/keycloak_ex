# Intro

A Keycloak client to easily manage authentication, with minimum effort. KeycloakEx is made up of clients and plugs. There are 2 clients:

* `KeycloakEx.Client.User` - Requires a client to be setup in keycloak and for security should be the primary client to be used. The client is utilized to verify tokens and redirect if the token is incorrect.
* `KeycloakEx.Client.Admin` - Admin Client to easily connect with Keycloak admin REST API, so as to be able to manage keycloak or get information that is not possible from clients.

There are also 2 plugs. Each useful in different scenarios:

* `KeycloakEx.VerifyBearerToken` - Ideal for API scenarios where the token is not managed by the backend. Where the token is received in the header  as authorization bearer token. The plug will verify  the validity of the token and respond accordingly.
        
* `KeycloakEx.VerifySessionToken` - Ideal for Phoenix HTML/Live views but the token is managed by the backend. Plug would manage token in the session.
  
**NOTE**

  From keycloak 18 there where a number of update one of which is the removal of "auth" from the host_uri.
  The plugin was update to remove /auth from the uri by default. So if you are utilizing an older version of
  Keycloak its important to add "/auth" as part of the host_uri ex:  host_uri: "http://localhost:8081/auth"

# Setup

## User Client

To create a User Client. Add the following snippet in a config.exs file:
```elixir
config :test_app, TestApp.KeycloakClient,
    realm: "test_app",
    client_id: "testapp-portal",
    site: "http://localhost:4000",
    scope: "testapp_scope",
    host_uri: "http://localhost:8081",
    client_secret: "afdasfasfsf"
```

Create module with the user client code
```elixir
defmodule TestApp.KeycloakClient do
    use KeycloakEx.Client.User,
      otp_app: :test_app
end
```

## Admin Client

To create an Admin Client. Add the following snippet in a config.exs file:

```elixir
config :test_app, TestApp.KeycloakAdmin,
  realm: "master",
  username: "admin",
  password: "test123!",
  client_id: "admin-cli",
  host_uri: "http://localhost:8081"
```

Create module with the admin client code

```elixir
defmodule TestApp.KeycloakAdmin do
  use KeycloakEx.Client.Admin,
    otp_app: :test_app
end
```

## Plugs

As mentioned in the introduction the library has 2 different plugs which can be used in different scenarios.

### Verify Authorization Bearer Access Token

In the case when the access token is handled by a third party such as the front-end. Utilize the VerifyBearerToken, the plug would check the token and introspect the values of it and redirect if incorrect.

```elixir
plug KeycloakEx.VerifyBearerToken, client: TestApp.KeycloakClient
```

### Manage token from the backend.

In the case where the access token is managed by the backend in the plug session, utilize the VerifySessionToken.

```elixir
plug KeycloakEx.VerifySessionToken, client: TestApp.KeycloakClient
```

Its important to also handle the call back when handling the access token from the backend. For this add the following route in the phoenix router.ex.

```elixir
get "/login_cb", UserController, :login_redirect
```

In the controller its important to get the token from the code passed in the call back

```elixir
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
```
