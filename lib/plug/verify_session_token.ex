defmodule KeycloakEx.VerifySessionToken do
  import Plug.Conn

  require Logger

  def init(opts), do: opts

  defp refresh_token(conn, t, client) do
    case client.refresh_token(t) do
      {:ok, refresh_token} ->
        conn
        |> put_session(:token, refresh_token.token)

      {:error, err} ->
        Logger.error("[VerifySessionToken:refresh_token] - #{inspect(err)}")

        conn
        |> Phoenix.Controller.redirect(external: client.authorize_url!())
        |> halt()
    end
  end

  defp check_token_state(t, conn, client) do
    case client.introspect(t.access_token) do
      {:ok, %{"active" => true} = _resp} ->
        conn

      err ->
        Logger.error("[VerifySessionToken:introspect] - #{inspect(err)}")

        conn
        |> Phoenix.Controller.redirect(external: client.authorize_url!())
        |> halt()
    end
  end

  defp check_token(nil, conn, client) do
    conn
    |> Phoenix.Controller.redirect(external: client.authorize_url!())
    |> halt()
  end

  defp check_token(t, conn, client) do
    case OAuth2.AccessToken.expired?(t) do
      false ->
        # Token not expired verify that still valid
        check_token_state(t, conn, client)

      true ->
        refresh_token(conn, t, client)
    end
  end

  def call(conn, opts) do
    get_session(conn, :token)
    |> check_token(conn, opts[:client])
  end
end
