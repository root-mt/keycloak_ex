defmodule KeycloakEx.Client.Admin do

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @otp_app opts[:otp_app]
      use OAuth2.Strategy

      def config() do
        Application.get_env(@otp_app, __MODULE__, [])
      end

      def new do
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

      def child_spec() do
        conf = config()
        {
          Finch,
          name: __MODULE__,
          pools: %{
            :default => [size: 10],
            "#{conf[:host_uri]}" => [size: 32, count: 8]
          }
        }
      end

      defp response({:ok, resp}), do: Jason.decode!(resp.body)
      defp response(resp), do: resp

      def get_request(url, body \\ nil) do
        conf = config()

        :get
        |> Finch.build(
            "#{conf[:host_uri]}/auth/admin/realms/#{conf[:realm]}/#{url}",
            [
              {"Authorization", "Bearer #{get_token().token.access_token}"},
              {"Accept", "application/json"}
            ],
            body
          )
        |> Finch.request(__MODULE__)
        |> response
      end

      def get_users() do
        get_request("users")
      end

      def get_user(id) do
        get_request("users/#{id}")
      end

      def get_user_count() do
        get_request("users/count")
      end

      def get_users_profile() do
        get_request("users/profile")
      end
     end
  end
end