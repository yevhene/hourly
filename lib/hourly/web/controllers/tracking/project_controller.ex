defmodule Hourly.Web.Tracking.ProjectController do
  use Hourly.Web, :controller

  alias Hourly.Tracking
  alias Hourly.Tracking.Project

  action_fallback Hourly.Web.FallbackController

  def index(conn, _params) do
    user = conn.assigns.session.user
    projects = Tracking.list_projects(user)
    render(conn, "index.json", projects: projects)
  end

  def create(conn, %{"project" => params}) do
    user = conn.assigns.session.user
    with {:ok, %Project{} = project} <- Tracking.create_project(user, params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location",
        tracking_project_path(conn, :show, project))
      |> render("show.json", project: project)
    end
  end

  def show(conn, %{"id" => id}) do
    user = conn.assigns.session.user
    project = Tracking.get_project!(id, user)
    render(conn, "show.json", project: project)
  end

  def update(conn, %{"id" => id, "project" => params}) do
    user = conn.assigns.session.user
    project = Tracking.get_project!(id, user)
    with {
      :ok, %Project{} = project
    } <- Tracking.update_project(project, user, params) do
      render(conn, "show.json", project: project)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns.session.user
    project = Tracking.get_project!(id, user)
    with {:ok, %Project{}} <- Tracking.delete_project(project, user) do
      send_resp(conn, :no_content, "")
    end
  end
end
