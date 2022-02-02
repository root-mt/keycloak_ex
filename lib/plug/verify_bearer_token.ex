defmodule KeycloakEx.VerifyBearerToken do
  import Plug.Conn

  def init(opts), do: opts

  defp redirect_303(conn, url) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(303, Jason.encode!(%{"error" => "303", "error_description" => "Re-direct", "url" => url}))
    |> halt
  end

  defp check_token(nil, conn, client) do
    conn
    |> redirect_303(client.authorize_url!())
  end

  defp check_token(t, conn, client) do
    case client.get_token_state(t) do
      {:ok, resp} ->
          IO.inspect(resp)
          conn
      err ->
          err
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
    conn
    |> fetch_bearer()
    |> check_token(conn, opts[:client])
  end
end
