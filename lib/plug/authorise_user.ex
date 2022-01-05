defmodule Keycloak.AuthoriseUser do
  import Plug.Conn

  def init(opts), do: opts

  defp refresh_token(conn, t) do
    IO.puts("--- REFRESH Token")
    case Keycloak.Client.User.refresh_token(t) do
      {:ok, refresh_token} ->
        conn
        |> put_session(:token, refresh_token.token)
      {:error, err} ->
        conn
        |> send_resp(403, Jason.encode!(%{error: "Access Denied"}))
        |> halt()
    end

  end

  defp check_token(nil, conn), do: conn |> send_resp(403, Jason.encode!(%{error: "Access Denied"})) |> halt()

  defp check_token(t, conn) do
    case OAuth2.AccessToken.expired?(t) do
      false ->
        conn

      true ->
        refresh_token(conn, t)
    end
  end

  def call(conn, _) do
    get_session(conn, :token)
    |> check_token(conn)
  end
end
