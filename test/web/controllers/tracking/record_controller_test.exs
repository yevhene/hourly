defmodule Hourly.Web.Tracking.RecordControllerTest do
  use Hourly.Web.ConnCase

  alias Hourly.Tracking.Record

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index/2" do
    setup %{conn: conn, session: %{user: user}} do
      {:ok, conn: conn, record: insert(:record, user: user)}
    end

    test "lists all entries on index", %{conn: conn} do
      conn = get conn, tracking_record_path(conn, :index)

      assert length(json_response(conn, 200)["data"]) == 1
    end
  end

  describe "show/2" do
    setup %{conn: conn, session: %{user: user}} do
      {:ok, conn: conn, record: insert(:record, user: user)}
    end

    test "shows chosen resource", %{conn: conn, record: record} do
      conn = get conn, tracking_record_path(conn, :show,  record.id)

      assert json_response(conn, 200)["data"] == %{
        "id" => record.id,
        "started_at" => DateTime.to_iso8601(record.started_at),
        "finished_at" => DateTime.to_iso8601(record.finished_at),
        "comment" => record.comment,
        "user_id" => record.user_id,
        "project_id" => record.project_id,
        "inserted_at" => DateTime.to_iso8601(record.inserted_at),
        "updated_at" => DateTime.to_iso8601(record.updated_at)
      }
    end
  end

  describe "create/2" do
    test "creates record", %{conn: conn} do
      conn = post conn, tracking_record_path(conn, :create),
        record: params_for(:record)

      id = json_response(conn, 201)["data"]["id"]

      assert id
      assert Repo.get(Record, id)
    end

    test "does not creates record if data is invalid", %{conn: conn} do
      conn = post conn, tracking_record_path(conn, :create),
        record: params_for(:invalid_record)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update/2" do
    setup %{conn: conn, session: %{user: user}} do
      {:ok, conn: conn, record: insert(:record, user: user)}
    end

    test "updates record", %{conn: conn, record: record} do
      attrs = params_for(:record)
      conn = put conn, tracking_record_path(conn, :update, record),
        record: attrs

      assert json_response(conn, 200)["data"]["id"] == record.id
      assert Repo.get_by(Record, attrs)
    end

    test "does not updates record if data is invalid", %{
      conn: conn, record: record
    } do
      conn = put conn, tracking_record_path(conn, :update, record),
        record: params_for(:invalid_record)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete/2" do
    setup %{conn: conn, session: %{user: user}} do
      {:ok, conn: conn, record: insert(:record, user: user)}
    end

    test "deletes record", %{conn: conn, record: record} do
      conn = delete conn, tracking_record_path(conn, :delete, record)

      assert response(conn, 204)
      refute Repo.get(Record, record.id)
    end
  end
end
