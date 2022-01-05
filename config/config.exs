import Config

config :keycloak, :host_uri, "http://localhost:8081"

config :keycloak, Keycloak.Clients.Admin,
  realm: "master",
  username: "admin",
  password: "test123!",
  client_id: "admin-cli",
  client_secret: "83bf8d8e-e608-477b-b812-48b9ac4aa43a"

config :keycloak, Keycloak.Clients.User,
  realm: "keycloak-ex",
  client_id: "keycloak-ex",
  site: "https://localhost:4002",
  scope: "keycloak_scope"

#import_config "#{Mix.env()}.exs"
