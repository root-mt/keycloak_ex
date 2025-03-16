defmodule KeycloakTest do
  require Logger
  use ExUnit.Case
  alias KeycloakEx.{TestAdmin, TestUser, TestHelpers}
  # alias Testcontainers.Container

  setup_all do
    with {:ok,
          %{postgres_host_port: postgres_host_port, postgres_container_id: postgres_container_id}} <-
           TestHelpers.setup_postgres_test_container(),
         {:ok, %{keycloak_host_port: keycloak_host_port}} <-
           TestHelpers.setup_keycloak_test_container(
             postgres_container_id,
             to_string(postgres_host_port)
           ) do
      {:ok,
       %{
         keycloak_host_port: keycloak_host_port,
         postgres_host_port: postgres_host_port,
         postgres_container_id: postgres_container_id
       }}
    else
      error ->
        Logger.error("[KeycloakEx][Tests] Test setup failed. Error: #{inspect(error)}.")
        :error
    end
  end



  # Uncomment the test below to run an indefinite test to experiment with mock containers from outside the test environment.

  # @tag timeout: :infinity
  # describe "container runner" do
  #   test "start", %{
  #     keycloak_host_port: keycloak_host_port,
  #     postgres_host_port: postgres_host_port,
  #     postgres_container_id: postgres_container_id
  #   } do
  #     IO.puts("Keycloak host port #{inspect(keycloak_host_port)}")
  #     IO.puts("Postgres host port #{inspect(postgres_host_port)}")

  #     :timer.sleep(:infinity)
  #   end
  # end

  describe "Keycloak Admin" do
    test "config/0" do
      assert TestAdmin.config() == TestHelpers.test_admin()
    end
  end

  describe "Keycloak User" do
    test "config/0" do
      assert TestUser.config() == TestHelpers.test_user()
    end
  end
end
