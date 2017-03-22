defmodule Hourly.Web.Accounts.UserController do
  use Hourly.Web, :controller

  alias Hourly.Accounts
  alias Hourly.Accounts.User

  action_fallback Hourly.Web.FallbackController

  def create(conn, %{"user" => params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", accounts_user_path(conn, :show))
      |> render("show.json", user: user)
    end
  end

  def show(conn, _params) do
    user = conn.assigns.session.user

    render(conn, "show.json", user: user)
  end

  def update(conn, %{"user" => params}) do
    user = conn.assigns.session.user

    with {:ok, %User{} = user} <- Accounts.update_user(user, params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, _params) do
    user = conn.assigns.session.user

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
