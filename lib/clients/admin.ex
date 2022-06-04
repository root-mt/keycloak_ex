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

        OAuth2.Client.new(
          strategy: OAuth2.Strategy.Password,
          client_id: conf[:client_id],
          token_url:
            "#{conf[:host_uri]}/realms/#{conf[:realm]}/protocol/openid-connect/token"
        )
        |> OAuth2.Client.put_serializer("application/json", Jason)
      end

      def get_token(headers \\ []) do
        conf = config()

        OAuth2.Client.get_token!(
          new(),
          [username: conf[:username], password: conf[:password]],
          headers
        )
      end

      # Not needed for Login client
      def authorize_url(_client, _params \\ []) do
        nil
      end

      def get_token(_client, _params, _headers) do
        nil
      end

      defp response({:ok, resp}), do: Jason.decode!(resp.body)
      defp response(resp), do: resp

      def get_request_realm(realm, url, body \\ nil) do
        conf = config()

        OAuth2.Client.get(
          new(),
          "#{conf[:host_uri]}/admin/realms/#{realm}/#{url}",
          [
            {"Authorization", "Bearer #{get_token().token.access_token}"},
            {"Accept", "application/json"}
          ]
        )
      end

      def get_clients(realm) do
        get_request_realm(realm, "clients")
      end

      def get_users(realm) do
        get_request_realm(realm, "users")
      end

      def get_user_by_username(realm, username) do
        get_request_realm(realm, "users?username=#{username}")
      end

      def get_user(realm, id) do
        get_request_realm(realm, "users/#{id}")
      end

      def get_user_count(realm) do
        get_request_realm(realm, "users/count")
      end

      def get_users_profile(realm) do
        get_request_realm(realm, "users/profile")
      end
    end
  end
end
