defmodule Keycloak.Client.User do
  use OAuth2.Strategy

  def new do
    conf = Application.get_env(:keycloak, Keycloak.Clients.User)
    host = Application.get_env(:keycloak, :host_uri)

    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: conf[:client_id],
      redirect_uri: "#{conf[:site]}/login_cb",
      site: conf[:site],
      authorize_url: "#{host}/auth/realms/#{conf[:realm]}/protocol/openid-connect/auth",
      token_url: "#{host}/auth/realms/#{conf[:realm]}/protocol/openid-connect/token"
    ])
    |> OAuth2.Client.put_serializer("application/json", Jason)
  end

  def authorize_url!(params \\ []) do
    conf = Application.get_env(:keycloak, Keycloak.Clients.User)
    IO.puts("-- AUTHORISE URL")
    IO.inspect(conf)
    new()
    |> put_param(:scope, conf[:scope])
    |> OAuth2.Client.authorize_url!(params)
  end

  def get_token!(params \\ [], headers \\ []) do
    OAuth2.Client.get_token!(new(), params, headers)
  end

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end

  def refresh_token(t) do
    new()
    |> Map.put(:token, t)
    |> OAuth2.Client.refresh_token()
  end

end
