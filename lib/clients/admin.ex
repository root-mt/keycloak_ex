defmodule KeycloakEx.Client.Admin do

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @otp_app opts[:otp_app]
      use OAuth2.Strategy

      def config() do
        Application.get_env(@otp_app, __MODULE__, [])
      end

      def new do
    #   conf = Application.get_env(:keycloak, Keycloak.Clients.Admin)
    #    host = Application.get_env(:keycloak, :host_uri)
        conf = config()

        OAuth2.Client.new([
          strategy: OAuth2.Strategy.Password,
          client_id: conf[:client_id],
          token_url: "#{conf[:host_uri]}/auth/realms/#{conf[:realm]}/protocol/openid-connect/token"
        ])
        |> OAuth2.Client.put_serializer("application/json", Jason)
      end

      def get_token(headers \\ []) do
        conf = config()
        OAuth2.Client.get_token!(new(), [username: conf[:username], password: conf[:password]], headers)
      end
    end
  end
end
