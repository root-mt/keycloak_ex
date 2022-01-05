defmodule Keycloak.Clients.Admin do

  def new do
    conf = Application.get_env(:keycloak, Keycloak.Clients.Admin)
    host = Application.get_env(:keycloak, :host_uri)

    OAuth2.Client.new([
      strategy: OAuth2.Strategy.Password,
      client_id: conf[:client_id],
      token_url: "#{host}/auth/realms/#{conf[:realm]}/protocol/openid-connect/token"
    ])
    |> OAuth2.Client.put_serializer("application/json", Jason)
  end

  def get_token(headers \\ []) do
    conf = Application.get_env(:keycloak, Keycloak.Clients.Admin)
    OAuth2.Client.get_token!(new(), [username: conf[:username], password: conf[:password]], headers)
  end

end
