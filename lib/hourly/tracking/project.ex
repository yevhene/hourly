defmodule Hourly.Tracking.Project do
  use Ecto.Schema

  schema "tracking_projects" do
    field :name, :string

    belongs_to :user, Hourly.Accounts.User

    timestamps(type: :utc_datetime)
  end
end
