defmodule Hourly.Repo.Migrations.CreateHourly.Tracking.Record do
  use Ecto.Migration

  def change do
    create table(:tracking_records) do
      add :started_at, :utc_datetime, null: false
      add :finished_at, :utc_datetime

      add :comment, :string

      add :user_id, references(:accounts_users, on_delete: :delete_all),
        null: false
      add :project_id, references(:tracking_projects, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:tracking_records, [:user_id])
    create index(:tracking_records, [:project_id])
  end
end
