defmodule Hourly.Web.Tracking.ProjectControllerTest do
  use Hourly.Web.ConnCase

  alias Hourly.Tracking.Project

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index/2" do
    setup %{conn: conn, session: %{user: user}} do
      {:ok, conn: conn, project: insert(:project, user: user)}
    end

    test "lists all entries on index", %{conn: conn} do
      conn = get conn, tracking_project_path(conn, :index)

      assert length(json_response(conn, 200)["data"]) == 1
    end
  end

  describe "show/2" do
    setup %{conn: conn, session: %{user: user}} do
      {:ok, conn: conn, project: insert(:project, user: user)}
    end

    test "shows chosen resource", %{conn: conn, project: project} do
      conn = get conn, tracking_project_path(conn, :show,  project.id)

      assert json_response(conn, 200)["data"] == %{
        "id" => project.id,
        "name" => project.name,
        "user_id" => project.user_id,
        "inserted_at" => DateTime.to_iso8601(project.inserted_at),
        "updated_at" => DateTime.to_iso8601(project.updated_at)
      }
    end
  end

  describe "create/2" do
    @valid_attrs %{name: "project"}
    @invalid_attrs %{}

    test "creates project", %{conn: conn} do
      conn = post conn, tracking_project_path(conn, :create),
        project: @valid_attrs
      id = json_response(conn, 201)["data"]["id"]

      assert id
      assert Repo.get(Project, id)
    end

    test "does not creates project if data is invalid", %{conn: conn} do
      conn = post conn, tracking_project_path(conn, :create),
        project: @invalid_attrs

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update/2" do
    @valid_attrs %{name: "project"}
    @invalid_attrs %{name: nil}

    setup %{conn: conn, session: %{user: user}} do
      {:ok, conn: conn, project: insert(:project, user: user)}
    end

    test "updates project", %{conn: conn, project: project} do
      conn = put conn, tracking_project_path(conn, :update, project),
        project: @valid_attrs

      assert json_response(conn, 200)["data"]["id"] == project.id
      assert Repo.get_by(Project, @valid_attrs)
    end

    test "does not updates project if data is invalid", %{
      conn: conn, project: project
    } do
      conn = put conn, tracking_project_path(conn, :update, project),
        project: @invalid_attrs

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete/2" do
    setup %{conn: conn, session: %{user: user}} do
      {:ok, conn: conn, project: insert(:project, user: user)}
    end

    test "deletes project", %{conn: conn, project: project} do
      conn = delete conn, tracking_project_path(conn, :delete, project)

      assert response(conn, 204)
      refute Repo.get(Project, project.id)
    end
  end
end
