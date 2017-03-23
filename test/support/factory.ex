defmodule Hourly.Factory do
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  use ExMachina.Ecto, repo: Hourly.Repo

  def user_factory do
    %Hourly.Accounts.User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: "password",
      password_hash: hashpwsalt("password")
    }
  end

  def session_factory do
    %Hourly.Accounts.Session{
      user: build(:user),
      token: Hourly.Accounts.Utils.generate_token()
    }
  end

  def project_factory do
    %Hourly.Tracking.Project{
      user: build(:user),
      name: sequence(:name, &"project-#{&1}")
    }
  end
end
