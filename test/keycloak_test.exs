defmodule KeycloakTest do
  use ExUnit.Case
  alias KeycloakEx.{TestAdmin, TestUser, TestHelpers}

  setup_all do
    TestHelpers.setup_user_and_admin_config()
    TestHelpers.setup_keycloak_test_container()
    :ok
  end

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
