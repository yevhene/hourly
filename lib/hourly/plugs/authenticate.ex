defmodule Hourly.Plugs.Authenticate do
  import Plug.Conn

  alias Hourly.Accounts

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    case conn |> get_token do
      "Bearer " <> token ->
        session = Accounts.get_session(token)

        if session do
          conn |> assign(:session, session)
        else
          raise Hourly.UnauthrorizedError
        end
      _ ->
        raise Hourly.UnauthrorizedError
    end
  end

  defp get_token(conn) do
    conn
    |> get_req_header("authorization")
    |> List.first
  end
end
