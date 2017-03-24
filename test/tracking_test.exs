defmodule Hourly.TrackingTest do
  use Hourly.DataCase

  alias Hourly.Tracking
  alias Hourly.Tracking.Project
  alias Hourly.Tracking.Record

  setup do
    {:ok,
      user: insert(:user),
      another_user_project: insert(:project),
      another_user_record: insert(:record)}
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

  describe "get_project!/2" do
    setup %{user: user} do
      {:ok, project: insert(:project, user: user)}
    end

    test "returns the project", %{project: project, user: user} do
      assert Tracking.get_project!(project.id, user).id == project.id
    end

    test "not returns anothers user project", %{
      user: user, another_user_project: project
    } do
      assert_raise Ecto.NoResultsError, fn ->
        Tracking.get_project!(project.id, user).id == project.id
      end
    end
  end

  describe "create_project/2" do
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

  describe "update_project/3" do
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

  describe "delete_project/2" do
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

  describe "list_records/2" do
    setup %{user: user} do
      {:ok, record: insert(:record, user: user)}
    end

    test "returns user records", %{record: record, user: user} do
      records = Tracking.list_records(user)
      assert length(records) == 1
      assert List.first(records).id == record.id
    end
  end

  describe "get_record!/2" do
    setup %{user: user} do
      {:ok, record: insert(:record, user: user)}
    end

    test "returns the record", %{record: record, user: user} do
      assert Tracking.get_record!(record.id, user).id == record.id
    end

    test "not returns anothers user record", %{
      user: user, another_user_record: record
    } do
      assert_raise Ecto.NoResultsError, fn ->
        Tracking.get_record!(record.id, user).id == record.id
      end
    end
  end

  describe "create_record/2" do
    setup do
      {:ok, attrs: params_for(:record, user_id: nil)}
    end

    test "with valid data creates a record", %{user: user, attrs: attrs} do
      assert {:ok, %Record{} = record} = Tracking.create_record(user, attrs)
      assert DateTime.to_naive(record.started_at) == attrs.started_at
      assert DateTime.to_naive(record.finished_at) == attrs.finished_at
      assert record.comment == attrs.comment
      assert record.user_id == user.id
    end

    test "with no started_at fails", %{user: user, attrs: attrs} do
      assert {:error, %Ecto.Changeset{}} = Tracking.create_record(user, %{
        attrs | started_at: nil
      })
    end

    test "with anothers user project fails", %{
      user: user, another_user_project: project, attrs: attrs
    } do
      assert {:error, %Ecto.Changeset{}} = Tracking.create_record(user, Map.merge(attrs, %{
        project_id: project.id
      }))
    end
  end

  describe "update_record/3" do
    setup %{user: user} do
      {:ok,
        record: insert(:record, user: user),
        attrs: params_for(:record, user_id: nil)}
    end

    test "updates user record", %{
      record: existing_record, user: user, attrs: attrs
    } do
      assert {
        :ok, %Record{} = record
      } = Tracking.update_record(existing_record, user, attrs)
      assert DateTime.to_naive(record.started_at) == attrs.started_at
      assert DateTime.to_naive(record.finished_at) == attrs.finished_at
      assert record.comment == attrs.comment
      assert record.user_id == user.id
    end

    test "with no started_at fails", %{
      record: existing_record, user: user, attrs: attrs
    } do
      assert {:error, %Ecto.Changeset{}} = Tracking.update_record(
        existing_record, user, %{attrs | started_at: nil}
      )
    end

    test "with anothers user project fails", %{
      record: existing_record, user: user, another_user_project: project, attrs: attrs
    } do
      assert {:error, %Ecto.Changeset{}} = Tracking.update_record(
        existing_record, user, Map.merge(attrs, %{project_id: project.id})
      )
    end

    test "not updates another user record", %{
      another_user_record: record, user: user, attrs: attrs
    } do
      assert_raise Hourly.UnauthrorizedError, fn ->
        Tracking.update_record(record, user, attrs)
      end

      assert Repo.get(Record, record.id).comment != attrs.comment
    end
  end

  describe "delete_record/2" do
    setup %{user: user} do
      {:ok, record: insert(:record, user: user)}
    end

    test "deletes the record", %{record: record, user: user} do
      assert {:ok, %Record{}} = Tracking.delete_record(record, user)
      refute Repo.get(Record, record.id)
    end

    test "not deletes another user record", %{
      another_user_record: record, user: user
    } do
      assert_raise Hourly.UnauthrorizedError, fn ->
        Tracking.delete_record(record, user)
      end
      assert Repo.get(Record, record.id)
    end
  end
end
