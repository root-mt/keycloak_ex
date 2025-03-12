defmodule KeycloakEx.TestHelpers do
  require Logger

  def setup_user_and_admin_config() do
    Logger.info("[KeycloakEx][Tests] Setting user and admin config")

    Config.Reader.read!("test/support/config.exs")
    |> Application.put_all_env()
  end

  def setup_keycloak_test_container() do
    Logger.info("[KeycloakEx][Tests] Setting Keycloak test container")
  end

  def test_user() do
    [
      realm: "test",
      client_id: "test_client",
      site: "http://localhost:4000",
      scope: "test_scope",
      client_secret: "vHcvRhDrMakeXviFj2SnC5zLjDjEXJEJ",
      host_uri: "http://localhost:18080"
    ]
  end

  def test_admin() do
    [
      realm: "master",
      username: "admin",
      password: "test123!",
      client_id: "admin-cli",
      host_uri: "http://localhost:18080"
    ]
  end
end
