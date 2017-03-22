defmodule Hourly.AccountsTest do
  use Hourly.DataCase

  import Comeonin.Bcrypt, only: [checkpw: 2]

  alias Hourly.Accounts
  alias Hourly.Accounts.User
  alias Hourly.Accounts.Session

  describe "create_user/1" do
    @attrs %{
      email: "user@example.com",
      password: "password"
    }

    test "with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@attrs)
      assert user.email == @attrs.email
      assert checkpw(@attrs.password, user.password_hash)
    end

    test "without password returns error" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{
        @attrs | password: nil
      })
    end

    test "without email returns error" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{
        @attrs | email: nil
      })
    end

    test "with email of wrong format returns error" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{
        @attrs | email: "wrong"
      })
    end

    test "with short password returns error" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{
        @attrs | password: "short"
      })
    end
  end

  describe "update_user/2" do
    @attrs %{
      email: "another-user@example.com",
      password: "another-password"
    }

    setup do
      {:ok, user: insert(:user)}
    end

    test "with valid data creates a user", %{user: user} do
      assert {:ok, user} = Accounts.update_user(user, @attrs)
      assert %User{} = user
      assert user.email == @attrs.email
      assert checkpw(@attrs.password, user.password_hash)
    end

    test "without email returns error", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, %{
        @attrs | email: nil
      })
    end

    test "with email of wrong format returns error", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, %{
        @attrs | email: "wrong"
      })
    end

    test "with showrt password returns error", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, %{
        @attrs | password: "short"
      })
    end
  end

  describe "delete_user/1" do
    setup do
      {:ok, user: insert(:user)}
    end

    test "deletes the user", %{user: user} do
      assert {:ok, %User{}} = Accounts.delete_user(user)
      refute Repo.get(User, user.id)
    end
  end

  describe "#get_session/1" do
    setup do
      {:ok, session: insert(:session)}
    end

    test "returns session", %{session: session} do
      returned_session = Accounts.get_session(session.token)
      assert %Session{} = returned_session
      assert returned_session.id == session.id
    end
  end

  describe "create_session/1" do
    setup do
      {:ok, user: insert(:user)}
    end

    test "with valid data creates a session", %{user: user} do
      assert {:ok, %Session{} = session} = Accounts.create_session(%{
        email: user.email, password: user.password
      })
      assert session.token != nil
      assert session.user_id == user.id
    end

    test "without email returns error", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_session(%{
        email: nil, password: user.password
      })
    end

    test "with wrong returns error", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_session(%{
        email: "wrong", password: user.password
      })
    end

    test "without password returns error", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_session(%{
        email: user.email, password: nil
      })
    end

    test "with wrong password returns error", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_session(%{
        email: user.email, password: "wrong"
      })
    end
  end

  describe "delete_session/1" do
    setup do
      {:ok, session: insert(:session)}
    end

    test "deletes the session", %{session: session} do
      assert {:ok, %Session{}} = Accounts.delete_session(session)
      refute Repo.get(Session, session.id)
    end
  end
end
