defmodule Hourly.Accounts.Utils do
  import Ecto.{Changeset}, warn: false
  import Comeonin.Bcrypt, only: [checkpw: 2, hashpwsalt: 1]

  alias Hourly.Repo
  alias Hourly.Accounts.User

  def authenticate(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{
        email: email, password: password
      }} ->
        if user = Repo.get_by(User, %{email: email}) do
          if checkpw(password, user.password_hash) do
            put_change(changeset, :user_id, user.id)
          else
            add_error(changeset, :credentials, "wrong")
          end
        else
          add_error(changeset, :credentials, "wrong")
        end
      _ ->
        changeset
    end
  end

  def generate_token(length \\ 64) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64
    |> binary_part(0, length)
  end

  def hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
