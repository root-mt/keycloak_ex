defmodule TestAdmin.KeycloakUser do
  # Test module for Key

  use KeycloakEx.Client.User,
    otp_app: :bp_apiserver
end
