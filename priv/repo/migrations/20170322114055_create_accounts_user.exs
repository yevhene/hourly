defmodule Hourly.Repo.Migrations.CreateHourly.Accounts.User do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :email, :text, null: false
      add :password_hash, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:accounts_users, [:email], unique: true)
  end
end
