defmodule Hourly.Repo.Migrations.CreateHourly.Tracking.Project do
  use Ecto.Migration

  def change do
    create table(:tracking_projects) do
      add :name, :string

      add :user_id, references(:accounts_users, on_delete: :delete_all),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index(:tracking_projects, [:user_id, :name],
                 unique: true, name: :tracking_projects_user_id_name_index)
  end
end
