defmodule KeycloakEx.TestHelpers do
  require Logger
  alias Testcontainers.Container

  def setup_user_and_admin_config() do
    Logger.info("[KeycloakEx][Tests] Setting user and admin config")

    Config.Reader.read!("test/support/config.exs")
    |> Application.put_all_env()
  end

  def setup_postgres_test_container() do
  end

  defp postgres_config() do
  end

  def setup_keycloak_test_container() do
    Logger.info("[KeycloakEx][Tests] Setting Keycloak test container")
    {:ok, container} = Testcontainers.start_container(keycloak_config())
    ExUnit.Callbacks.on_exit(fn -> Testcontainers.stop_container(container.container_id) end)
    {:ok, %{keycloak: container}}
  end

  defp keycloak_config() do
    %Container{image: "quay.io/keycloak/keycloak:24.0"}
    |> Container.with_environment(:KEYCLOAK_CREATE_ADMIN_USER, "true")
    |> Container.with_environment(:KEYCLOAK_ADMIN, "admin")
    |> Container.with_environment(:KEYCLOAK_ADMIN_PASSWORD, "test123!")
    |> Container.with_environment(:KC_DB, "postgres")
    |> Container.with_environment(:KC_DB_URL_HOST, "postgres")
    |> Container.with_environment(:KC_DB_USERNAME, "postgres")
    |> Container.with_environment(:KC_DB_PASSWORD, "postgres")
    |> Container.with_environment(:KC_DB_URL_PORT, "5432")
    |> Container.with_exposed_port(8080)
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
