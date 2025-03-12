defmodule TestAdmin.KeycloakUser do
  # Test module for Key

  use KeycloakEx.Client.User,
    otp_app: :keycloak_ex
end
