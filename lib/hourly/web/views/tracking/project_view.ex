defmodule Hourly.Web.Tracking.ProjectView do
  use Hourly.Web, :view
  alias Hourly.Web.Tracking.ProjectView

  def render("index.json", %{projects: projects}) do
    %{data: render_many(projects, ProjectView, "project.json")}
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, ProjectView, "project.json")}
  end

  def render("project.json", %{project: project}) do
    %{id: project.id,
      name: project.name,
      user_id: project.user_id,
      inserted_at: project.inserted_at,
      updated_at: project.updated_at}
  end
end
