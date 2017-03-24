defmodule Hourly.Factory do
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  use ExMachina.Ecto, repo: Hourly.Repo

  alias Hourly.Accounts.Session
  alias Hourly.Accounts.User
  alias Hourly.Tracking.Project
  alias Hourly.Tracking.Record

  def user_factory do
    %User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: "password",
      password_hash: hashpwsalt("password")
    }
  end

  def session_factory do
    %Session{
      user: build(:user),
      token: Hourly.Accounts.Utils.generate_token()
    }
  end

  def project_factory do
    %Project{
      user: build(:user),
      name: sequence(:name, &"project-#{&1}")
    }
  end

  def invalid_project_factory do
    %Project{
      name: ""
    }
  end

  def record_factory do
    %Record{
      started_at: NaiveDateTime.utc_now,
      finished_at: NaiveDateTime.utc_now |> NaiveDateTime.add(60 * 60),
      comment: sequence(:comment, &"comment-#{&1}"),
      user: build(:user),
      project: build(:project)
    }
  end

  def invalid_record_factory do
    %Record{
      started_at: ""
    }
  end
end
