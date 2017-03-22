defmodule Hourly.Accounts do
  import Ecto.{Query, Changeset}, warn: false
  import Hourly.Accounts.Utils

  alias Hourly.Repo
  alias Hourly.Accounts.User
  alias Hourly.Accounts.Session

  def create_user(attrs \\ %{}) do
    %User{}
    |> create_user_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs \\ %{}) do
    user
    |> user_changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  defp create_user_changeset(%User{} = user, attrs) do
    user
    |> user_changeset(attrs)
    |> validate_required([:password])
  end

  defp user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> hash_password()
  end

  def get_session(token) do
    Repo.get_by(Session, token: token) |> Repo.preload(:user)
  end

  def create_session(attrs \\ %{}) do
    %Session{}
    |> session_changeset(attrs)
    |> Repo.insert()
  end

  def delete_session(%Session{} = session) do
    Repo.delete(session)
  end

  defp session_changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> authenticate()
    |> put_change(:token, generate_token())
  end
end
