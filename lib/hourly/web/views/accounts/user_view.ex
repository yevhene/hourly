defmodule Hourly.Web.Accounts.UserView do
  use Hourly.Web, :view
  alias Hourly.Web.Accounts.UserView

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at}
  end
end
