defmodule Hourly.Web.Accounts.SessionController do
  use Hourly.Web, :controller

  alias Hourly.Accounts
  alias Hourly.Accounts.Session

  action_fallback Hourly.Web.FallbackController

  def create(conn, %{"session" => params}) do
    with {:ok, %Session{} = session} <- Accounts.create_session(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", accounts_session_path(conn, :show))
      |> render("show.json", session: session)
    end
  end

  def show(conn, _params) do
    session = conn.assigns.session

    render(conn, "show.json", session: session)
  end

  def delete(conn, _params) do
    session = conn.assigns.session

    with {:ok, %Session{}} <- Accounts.delete_session(session) do
      send_resp(conn, :no_content, "")
    end
  end
end
