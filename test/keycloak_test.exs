defmodule KeycloakTest do
  use ExUnit.Case
  doctest Keycloak

  test "greets the world" do
    assert Keycloak.hello() == :world
  end
end
