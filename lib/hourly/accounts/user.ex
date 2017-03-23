defmodule Hourly.Accounts.User do
  use Ecto.Schema

  schema "accounts_users" do
    field :email, :string
    field :password_hash, :string

    field :password, :string, virtual: true

    has_many :sessions, Hourly.Accounts.Session
    has_many :projects, Hourly.Tracking.Project

    timestamps(type: :utc_datetime)
  end
end
