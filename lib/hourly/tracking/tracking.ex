defmodule Hourly.Tracking do
  import Ecto.{Query, Changeset}, warn: false
  alias Hourly.Repo

  alias Hourly.Tracking.Project
  alias Hourly.Accounts.User

  def list_projects(%User{} = user) do
    scope(user)
    |> Repo.all()
  end

  def get_project!(id, %User{} = user) do
    scope(user)
    |> Repo.get!(id)
  end

  def create_project(%User{} = user, attrs \\ %{}) do
    %Project{}
    |> project_changeset(%User{} = user, attrs)
    |> Repo.insert()
  end

  def update_project(%Project{} = project, %User{} = user, attrs) do
    project
    |> authorize!(user)
    |> project_changeset(%User{} = user, attrs)
    |> Repo.update()
  end

  def delete_project(%Project{} = project, %User{} = user) do
    project
    |> authorize!(user)
    |> Repo.delete()
  end

  defp project_changeset(%Project{} = project, %User{} = user, attrs) do
    project
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> put_change(:user_id, user.id)
    |> unique_constraint(:name, name: :tracking_projects_user_id_name_index)
  end

  defp scope(%User{} = user) do
    Project
    |> where([p], ^user.id == p.user_id)
  end

  defp authorize!(%Project{} = project, %User{} = user) do
    if project.user_id == user.id do
      project
    else
      raise Hourly.UnauthrorizedError
    end
  end
end
