defmodule KeycloakEx.TestHelpers do
  require Logger
  alias Testcontainers.{Container, LogWaitStrategy}

  def setup_user_and_admin_config(keycloak_host_port) do
    Logger.info("[KeycloakEx][Tests] Setting user and admin config")
    host_uri = "http://localhost:#{keycloak_host_port}"
    put_test_user_env(host_uri)
    put_test_admin_env(host_uri)
  end

  defp put_test_user_env(host_uri) do
    Application.put_env(:keycloak_ex, KeycloakEx.TestUser,
      realm: "test",
      client_id: "test_client",
      site: "http://localhost:4000",
      scope: "test_scope",
      client_secret: "vHcvRhDrMakeXviFj2SnC5zLjDjEXJEJ",
      host_uri: host_uri
    )
  end

  def put_test_admin_env(host_uri) do
    Application.put_env(:keycloak_ex, KeycloakEx.TestAdmin,
      realm: "master",
      username: "admin",
      password: "test123!",
      client_id: "admin-cli",
      host_uri: host_uri
    )
  end

  def setup_postgres_test_container() do
    Logger.info("[KeycloakEx][Tests] Setting Postgres test container")
    {:ok, container} = Testcontainers.start_container(postgres_config())
    ExUnit.Callbacks.on_exit(fn -> Testcontainers.stop_container(container.container_id) end)

    {:ok,
     %{
       postgres_host_port: Container.mapped_port(container, 5432),
       postgres_container_id: container.container_id
     }}
  end

  def postgres_config() do
    %Container{image: "postgres:16.1"}
    |> Container.with_environment(:POSTGRES_USER, "postgres")
    |> Container.with_environment(:POSTGRES_PASSWORD, "postgres")
    |> Container.with_environment(:POSTGRES_DB, "postgres")
    |> Container.with_exposed_port(5432)
    |> Container.with_bind_mount(
      File.cwd!() <> "/test/support/init-scripts/keyloak-setup.sql",
      "/docker-entrypoint-initdb.d/keycloak-setup.sql"
    )
    |> Container.with_waiting_strategy(
      LogWaitStrategy.new(
        ~r/database system is ready to accept connections*/,
        200_000
      )
    )
  end

  def setup_keycloak_test_container(postgres_container_id, postgres_host_port) do
    Logger.info("[KeycloakEx][Tests] Setting Keycloak test container")

    {:ok, container} =
      Testcontainers.start_container(keycloak_config(postgres_container_id, postgres_host_port))

    ExUnit.Callbacks.on_exit(fn -> Testcontainers.stop_container(container.container_id) end)

    {:ok, %{keycloak_host_port: Container.mapped_port(container, 8080)}}
  end

  defp keycloak_config(postgres_container_id, postgres_host_port) do
    Logger.info(
      "[KeycloakEx][Tests] Database config for Keycloak - Postgres Container ID: #{inspect(postgres_container_id)}, Postgres Host Port: #{inspect(postgres_host_port)}"
    )

    %Container{image: "quay.io/keycloak/keycloak:24.0"}
    |> Container.with_environment(:KEYCLOAK_CREATE_ADMIN_USER, "true")
    |> Container.with_environment(:KEYCLOAK_ADMIN, "admin")
    |> Container.with_environment(:KEYCLOAK_ADMIN_PASSWORD, "test123!")
    |> Container.with_environment(:KC_DB, "postgres")
    |> Container.with_environment(
      :KC_DB_URL,
      "jdbc:postgresql://172.17.0.1:#{postgres_host_port}/postgres"
    )
    |> Container.with_environment(:KC_DB_USERNAME, "postgres")
    |> Container.with_environment(:KC_DB_PASSWORD, "postgres")
    |> Container.with_exposed_port(8080)
    |> Container.with_bind_mount(
      File.cwd!() <> "/test/support/init-scripts/test-realm.json",
      "/opt/keycloak/data/import/test-realm.json"
    )
    |> Container.with_cmd(["start-dev", "--import-realm"])
    |> Container.with_waiting_strategy(
      LogWaitStrategy.new(
        ~r/Running the server in development mode*/,
        # time out
        200_000
      )
    )
  end

  def test_user(keycloak_host_port) do
    [
      realm: "test",
      client_id: "test_client",
      site: "http://localhost:4000",
      scope: "test_scope",
      client_secret: "vHcvRhDrMakeXviFj2SnC5zLjDjEXJEJ",
      host_uri: "http://localhost:#{keycloak_host_port}"
    ]
  end

  def test_admin(keycloak_host_port) do
    [
      realm: "master",
      username: "admin",
      password: "test123!",
      client_id: "admin-cli",
      host_uri: "http://localhost:#{keycloak_host_port}"
    ]
  end

  def test_admin_oauth2_client(keycloak_host_port) do
    %OAuth2.Client{
      authorize_url: "/oauth/authorize",
      client_id: "admin-cli",
      client_secret: "",
      headers: [],
      params: %{},
      redirect_uri: "",
      ref: nil,
      request_opts: [],
      serializers: %{"application/json" => Jason},
      site: "",
      strategy: OAuth2.Strategy.Password,
      token: nil,
      token_method: :post,
      token_url:
        "http://localhost:#{keycloak_host_port}/realms/master/protocol/openid-connect/token"
    }
  end
end
