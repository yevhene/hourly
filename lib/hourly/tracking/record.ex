defmodule Hourly.Tracking.Record do
  use Ecto.Schema

  schema "tracking_records" do
    field :started_at, :utc_datetime
    field :finished_at, :utc_datetime

    field :comment, :string

    belongs_to :project, Hourly.Tracking.Project
    belongs_to :user, Hourly.Accounts.User

    timestamps(type: :utc_datetime)
  end
end
