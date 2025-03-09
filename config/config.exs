import Config

config :keycloak, :host_uri, "http://localhost:8081"
config :oauth2, adapter: Tesla.Adapter.Mint

config :keycloak, Keycloak.Clients.Admin,
  realm: "master",
  username: "admin",
  password: "test123!",
  client_id: "admin-cli"

config :keycloak, Keycloak.Clients.User,
  realm: "keycloak-ex",
  client_id: "keycloak-ex",
  site: "https://localhost:4002",
  scope: "keycloak_scope",
  client_secret: "asdfsdfdsffsdfsdfs"
