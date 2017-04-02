defmodule Hourly.Web.Tracking.RecordController do
  use Hourly.Web, :controller

  alias Hourly.Tracking
  alias Hourly.Tracking.Record

  action_fallback Hourly.Web.FallbackController

  def index(conn, _params) do
    user = conn.assigns.session.user
    records = Tracking.list_records(user)
    render(conn, "index.json", records: records)
  end

  def create(conn, %{"record" => params}) do
    user = conn.assigns.session.user
    with {:ok, %Record{} = record} <- Tracking.create_record(user, params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", tracking_record_path(conn, :show, record))
      |> render("show.json", record: record)
    end
  end

  def show(conn, %{"id" => id}) do
    user = conn.assigns.session.user
    record = Tracking.get_record!(id, user)
    render(conn, "show.json", record: record)
  end

  def update(conn, %{"id" => id, "record" => params}) do
    user = conn.assigns.session.user
    record = Tracking.get_record!(id, user)

    with {
      :ok, %Record{} = record
    } <- Tracking.update_record(record, user, params) do
      render(conn, "show.json", record: record)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns.session.user
    record = Tracking.get_record!(id, user)
    with {:ok, %Record{}} <- Tracking.delete_record(record, user) do
      send_resp(conn, :no_content, "")
    end
  end
end
