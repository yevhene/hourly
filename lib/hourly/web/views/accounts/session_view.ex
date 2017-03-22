defmodule Hourly.Web.Accounts.SessionView do
  use Hourly.Web, :view
  alias Hourly.Web.Accounts.SessionView

  def render("show.json", %{session: session}) do
    %{data: render_one(session, SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{id: session.id,
      token: session.token,
      user_id: session.user_id,
      inserted_at: session.inserted_at,
      updated_at: session.updated_at}
  end
end
