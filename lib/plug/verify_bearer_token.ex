defmodule KeycloakEx.VerifyBearerToken do
  import Plug.Conn

  require Logger

  def init(opts), do: opts

  defp redirect_303(conn, url) do
    Logger.debug("[Plug][KeycloakEx.VerifyBearerToken] - No Token!")

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      303,
      Jason.encode!(%{"error" => "303", "error_description" => "Re-direct", "url" => url})
    )
    |> halt
  end

  defp redirect_401(conn) do
    Logger.debug("[Plug][KeycloakEx.VerifyBearerToken] - Unauthorised Token!")

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{"error" => "401", "error_description" => "Unauthorised"}))
    |> halt
  end

  defp check_token(nil, conn, client) do
    conn
    |> redirect_303(client.authorize_url!())
  end

  defp check_token(t, conn, client) do
    case client.introspect(t) do
      {:ok, %{"active" => true} = _resp} ->
        conn

      _err ->
        redirect_401(conn)
    end
  end

  defp fetch_bearer(conn) do
    conn
    |> Plug.Conn.get_req_header("authorization")
    |> hd
    |> String.split(" ")
    |> List.last()
  end

  def call(conn, opts) do
    Logger.debug("[Plug][KeycloakEx.VerifyBearerToken] - Check Token!")

    conn
    |> fetch_bearer()
    |> check_token(conn, opts[:client])
  end
end
