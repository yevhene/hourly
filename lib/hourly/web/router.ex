defmodule Hourly.Web.Router do
  use Hourly.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Hourly.Web do
    pipe_through :api
  end
end
