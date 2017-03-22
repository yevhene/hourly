defmodule Hourly.Repo.Migrations.CreateHourly.Accounts.Session do
  use Ecto.Migration

  def change do
    create table(:accounts_sessions) do
      add :token, :text, null: false
      add :expired_at, :utc_datetime

      add :user_id, references(:accounts_users, on_delete: :delete_all),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index(:accounts_sessions, [:user_id])
    create index(:accounts_sessions, [:token], unique: true)
  end
end
