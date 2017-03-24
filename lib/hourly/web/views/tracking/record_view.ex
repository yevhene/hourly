defmodule Hourly.Web.Tracking.RecordView do
  use Hourly.Web, :view
  alias Hourly.Web.Tracking.RecordView

  def render("index.json", %{records: records}) do
    %{data: render_many(records, RecordView, "record.json")}
  end

  def render("show.json", %{record: record}) do
    %{data: render_one(record, RecordView, "record.json")}
  end

  def render("record.json", %{record: record}) do
    %{id: record.id,
      started_at: record.started_at,
      finished_at: record.finished_at,
      comment: record.comment,
      user_id: record.user_id,
      project_id: record.project_id,
      inserted_at: record.inserted_at,
      updated_at: record.updated_at}
  end
end
