import Config

config :keycloak_ex, KeycloakEx.TestUser,
  realm: "test",
  client_id: "test_client",
  site: "http://localhost:4000",
  scope: "test_scope",
  client_secret: "vHcvRhDrMakeXviFj2SnC5zLjDjEXJEJ",
  host_uri: "http://localhost:18080"

config :keycloak_ex, KeycloakEx.TestAdmin,
  realm: "master",
  username: "admin",
  password: "test123!",
  client_id: "admin-cli",
  host_uri: "http://localhost:18080"
