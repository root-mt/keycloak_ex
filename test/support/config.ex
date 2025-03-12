import Config

config :keycloak_ex, KeycloakEx.Client.User,
  realm: "test",
  client_id: "test_client",
  site: "http://localhost:4000",
  scope: "test_scope",
  client_secret: "vHcvRhDrMakeXviFj2SnC5zLjDjEXJEJ",
  host_uri: "http://localhost:18080"

config :keycloak_ex, KeycloakEx.Client.Admin,
  realm: "test",
  client_id: "test_client",
  site: "http://localhost:4000",
  scope: "test_scope",
  client_secret: "vHcvRhDrMakeXviFj2SnC5zLjDjEXJEJ",
  host_uri: "http://localhost:18080"

def test_client() do
  %{
    "clientId" => "test_client",
    "rootUrl" => "http://localhost:4000",
    "adminUrl" => "http://localhost:4000",
    "surrogateAuthRequired" => false,
    "enabled" => true,
    "alwaysDisplayInConsole" => false,
    "clientAuthenticatorType" => "client-secret",
    "secret" => "vHcvRhDrMakeXviFj2SnC5zLjDjEXJEJ",
    "redirectUris" => [
      "http://localhost:4000/login_cb"
    ],
    "webOrigins" => [
      "http://localhost:4000"
    ],
    "notBefore" => 0,
    "bearerOnly" => false,
    "consentRequired" => false,
    "standardFlowEnabled" => true,
    "implicitFlowEnabled" => true,
    "directAccessGrantsEnabled" => true,
    "serviceAccountsEnabled" => false,
    "publicClient" => false,
    "frontchannelLogout" => false,
    "protocol" => "openid-connect",
    "attributes" => %{
      "saml.force.post.binding" => "false",
      "saml.multivalued.roles" => "false",
      "post.logout.redirect.uris" => "+",
      "oauth2.device.authorization.grant.enabled" => "true",
      "backchannel.logout.revoke.offline.tokens" => "false",
      "saml.server.signature.keyinfo.ext" => "false",
      "use.refresh.tokens" => "true",
      "oidc.ciba.grant.enabled" => "false",
      "backchannel.logout.session.required" => "true",
      "client_credentials.use_refresh_token" => "false",
      "require.pushed.authorization.requests" => "false",
      "saml.client.signature" => "false",
      "id.token.as.detached.signature" => "false",
      "saml.assertion.signature" => "false",
      "saml.encrypt" => "false",
      "login_theme" => "keycloak",
      "saml.server.signature" => "false",
      "exclude.session.state.from.auth.response" => "false",
      "saml.artifact.binding" => "false",
      "saml_force_name_id_format" => "false",
      "tls.client.certificate.bound.access.tokens" => "false",
      "saml.authnstatement" => "false",
      "display.on.consent.screen" => "false",
      "saml.onetimeuse.condition" => "false"
    },
    "authenticationFlowBindingOverrides" => %{},
    "fullScopeAllowed" => true,
    "nodeReRegistrationTimeout" => -1,
    "defaultClientScopes" => [
      "web-origins",
      "profile",
      "roles",
      "email"
    ],
    "optionalClientScopes" => [
      "address",
      "phone",
      "offline_access",
      "microprofile-jwt"
    ],
    "access" => %{
      "view" => true,
      "configure" => true,
      "manage" => true
    }
  }
end
