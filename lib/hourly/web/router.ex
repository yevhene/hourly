defmodule Hourly.Web.Router do
  use Hourly.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Hourly.Plugs.Authenticate
  end

  scope "/accounts", Hourly.Web.Accounts, as: :accounts do
    scope "/" do
      pipe_through :api

      resources "/session", SessionController,
        only: [:create], singleton: true
      resources "/user", UserController,
        only: [:create], singleton: true
    end

    scope "/" do
      pipe_through [:api, :auth]

      resources "/session", SessionController,
        only: [:show, :delete], singleton: true
      resources "/user", UserController,
        only: [:show, :update, :delete], singleton: true
    end
  end

  scope "/", Hourly.Web.Tracking, as: :tracking do
    pipe_through [:api, :auth]

    resources "/projects", ProjectController, except: [:new, :edit]
    resources "/records", RecordController, except: [:new, :edit]
  end
end
