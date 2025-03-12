defmodule TestAdmin.KeycloakAdmin do
  # Test module for Key

  use KeycloakEx.Client.Admin,
    otp_app: :keycloak_ex
end
