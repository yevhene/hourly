defmodule Hourly.Tracking do
  import Ecto.{Query, Changeset}, warn: false
  alias Hourly.Repo

  alias Hourly.Accounts.User
  alias Hourly.Tracking.Project
  alias Hourly.Tracking.Record

  def list_projects(%User{} = user) do
    scope(Project, user)
    |> Repo.all()
  end

  def get_project!(id, %User{} = user) do
    scope(Project, user)
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

  def list_records(%User{} = user) do
    scope(Record, user)
    |> Repo.all()
  end

  def get_record!(id, %User{} = user) do
    scope(Record, user)
    |> Repo.get!(id)
  end

  def create_record(%User{} = user, attrs \\ %{}) do
    %Record{}
    |> record_changeset(%User{} = user, attrs)
    |> Repo.insert()
  end

  def update_record(%Record{} = record, %User{} = user, attrs) do
    record
    |> authorize!(user)
    |> record_changeset(%User{} = user, attrs)
    |> Repo.update()
  end

  def delete_record(%Record{} = record, %User{} = user) do
    record
    |> authorize!(user)
    |> Repo.delete()
  end

  defp record_changeset(%Record{} = record, %User{} = user, attrs) do
    record
    |> cast(attrs, [:started_at, :finished_at, :project_id, :comment])
    |> validate_required([:started_at])
    |> put_change(:user_id, user.id)
    |> foreign_key_constraint(:project_id)
    |> validate_project_user(user)
  end

  defp scope(model, %User{} = user) do
    model
    |> where([p], ^user.id == p.user_id)
  end

  defp authorize!(entity, %User{} = user) do
    if entity.user_id == user.id do
      entity
    else
      raise Hourly.UnauthrorizedError
    end
  end

  defp validate_project_user(%Ecto.Changeset{} = changeset, user) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{project_id: project_id}} ->
        if Repo.get_by(Project, id: project_id, user_id: user.id) do
          changeset
        else
          add_error(changeset, :project_id, "not own")
        end
      _ ->
        changeset
    end
  end
end
