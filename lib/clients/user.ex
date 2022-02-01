defmodule KeycloakEx.Client.User do

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @otp_app opts[:otp_app]
      use OAuth2.Strategy

      def config() do
        Application.get_env(@otp_app, __MODULE__, [])
      end

      @spec new :: OAuth2.Client.t()
      def new do
        conf = config()

        OAuth2.Client.new([
          strategy: __MODULE__,
          client_id: conf[:client_id],
          redirect_uri: "#{conf[:site]}/login_cb",
          site: conf[:site],
          authorize_url: "#{conf[:host_uri]}/auth/realms/#{conf[:realm]}/protocol/openid-connect/auth",
          token_url: "#{conf[:host_uri]}/auth/realms/#{conf[:realm]}/protocol/openid-connect/token"
        ])
        |> OAuth2.Client.put_serializer("application/json", Jason)
      end

      def authorize_url!(params \\ []) do
        conf = config()

        new()
        |> put_param(:scope, conf[:scope])
        |> OAuth2.Client.authorize_url!(params)
      end

      def get_token!(params \\ [], headers \\ []) do
        OAuth2.Client.get_token!(new(), params, headers)
      end

      def authorize_url(client, params \\ []) do
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

      def get_token_state(access_token) do
        conf = config()

        OAuth2.Client.get(
          new(),
          "#{conf[:host_uri]}/auth/admin/realms/#{conf[:realm]}/protocol/openid-connect/token/introspect",
          [
            {"Authorization", "Bearer #{access_token}"},
            {"Accept", "application/json"}
          ]
        )
      end
    end
  end
end
