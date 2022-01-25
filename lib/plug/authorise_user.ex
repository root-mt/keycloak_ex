defmodule KeycloakEx.AuthoriseUser do
  import Plug.Conn

  def init(opts), do: opts

  defp refresh_token(conn, t, client) do
    case client.refresh_token(t) do
      {:ok, refresh_token} ->
        conn
        |> put_session(:token, refresh_token.token)
      {:error, err} ->
        conn
        |> send_resp(403, Jason.encode!(%{error: "Access Denied"}))
        |> halt()
    end

  end

  defp check_token(nil, conn, client) do
    conn
    |> Phoenix.Controller.redirect(external: client.authorize_url!())
  end

  defp check_token(t, conn, client) do
    case OAuth2.AccessToken.expired?(t) do
      false ->
        conn

      true ->
        refresh_token(conn, t, client)
    end
  end

  def call(conn, opts) do
    get_session(conn, :token)
    |> check_token(conn, opts[:client])
  end
end
