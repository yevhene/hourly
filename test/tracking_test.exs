defmodule Hourly.TrackingTest do
  use Hourly.DataCase

  alias Hourly.Tracking
  alias Hourly.Tracking.Project

  setup do
    another_user_project = insert(:project)
    {:ok, user: insert(:user), another_user_project: another_user_project}
  end

  describe "list_projects/2" do
    setup %{user: user} do
      {:ok, project: insert(:project, user: user)}
    end

    test "returns user projects", %{project: project, user: user} do
      projects = Tracking.list_projects(user)
      assert length(projects) == 1
      assert List.first(projects).id == project.id
    end
  end

  describe "get_project!/1" do
    setup %{user: user} do
      {:ok, project: insert(:project, user: user)}
    end

    test "returns the project", %{project: project, user: user} do
      assert Tracking.get_project!(project.id, user).id == project.id
    end

    test "not returns another user project", %{
      user: user, another_user_project: project
    } do
      assert_raise Ecto.NoResultsError, fn ->
        Tracking.get_project!(project.id, user).id == project.id
      end
    end
  end

  describe "create_project/1" do
    setup do
      {:ok, attrs: params_for(:project, user_id: nil)}
    end

    test "with valid data creates a project", %{user: user, attrs: attrs} do
      assert {:ok, %Project{} = project} = Tracking.create_project(user, attrs)
      assert project.name == attrs.name
      assert project.user_id == user.id
    end

    test "with no name fails", %{user: user, attrs: attrs} do
      assert {:error, %Ecto.Changeset{}} = Tracking.create_project(user, %{
        attrs | name: nil
      })
    end

    test "with non unique name in user scope fails", %{
      user: user, attrs: attrs
    } do
      assert {:ok, %Project{}} = Tracking.create_project(user, attrs)
      assert {:error, %Ecto.Changeset{}} = Tracking.create_project(user, attrs)
    end
  end

  describe "update_project/2" do
    setup %{user: user} do
      {:ok,
        project: insert(:project, user: user),
        attrs: params_for(:project, user_id: nil)}
    end

    test "updates user project", %{
      project: existing_project, user: user, attrs: attrs
    } do
      assert {
        :ok, %Project{} = project
      } = Tracking.update_project(existing_project, user, attrs)
      assert project.name == attrs.name
      assert project.user_id == user.id
    end

    test "with no name fails", %{
      project: existing_project, user: user, attrs: attrs
    } do
      assert {:error, %Ecto.Changeset{}} = Tracking.update_project(
        existing_project, user, %{attrs | name: nil}
      )
    end

    test "with non unique name in user scope fails", %{
      project: project, user: user, attrs: attrs
    } do
      assert {:ok, %Project{}} = Tracking.create_project(user, attrs)
      assert {:error, %Ecto.Changeset{}} = Tracking.update_project(
        project, user, attrs
      )
    end

    test "not updates another user project", %{
      another_user_project: project, user: user, attrs: attrs
    } do
      assert_raise Hourly.UnauthrorizedError, fn ->
        Tracking.update_project(project, user, attrs)
      end

      assert Repo.get(Project, project.id).name != attrs.name
    end
  end

  describe "delete_project/1" do
    setup %{user: user} do
      {:ok, project: insert(:project, user: user)}
    end

    test "deletes the project", %{project: project, user: user} do
      assert {:ok, %Project{}} = Tracking.delete_project(project, user)
      refute Repo.get(Project, project.id)
    end

    test "not deletes another user project", %{
      another_user_project: project, user: user
    } do
      assert_raise Hourly.UnauthrorizedError, fn ->
        Tracking.delete_project(project, user)
      end
      assert Repo.get(Project, project.id)
    end
  end
end
