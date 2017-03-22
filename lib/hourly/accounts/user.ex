defmodule Hourly.Accounts.User do
  use Ecto.Schema

  schema "accounts_users" do
    field :email, :string
    field :password_hash, :string

    field :password, :string, virtual: true

    has_many :sessions, Hourly.Accounts.Session

    timestamps(type: :utc_datetime)
  end
end
