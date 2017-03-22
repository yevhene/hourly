defmodule Hourly.Accounts.Session do
  use Ecto.Schema

  schema "accounts_sessions" do
    field :token, :string
    field :expired_at, :utc_datetime

    field :email, :string, virtual: true
    field :password, :string, virtual: true

    belongs_to :user, Hourly.Accounts.User

    timestamps(type: :utc_datetime)
  end
end
