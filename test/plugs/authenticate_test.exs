defmodule Hourly.Plugs.AuthenticateTest do
  use Hourly.Web.ConnCase, async: true

  setup do
    {:ok, session: insert(:session)}
  end

  test "user passed if correct token is present", %{session: session} do
    conn = build_conn()
    |> put_req_header("authorization", "Bearer #{session.token}")
    |> Hourly.Plugs.Authenticate.call(%{})

    assert conn.status != 401
    assert conn.assigns.session != nil
  end

  test "user not passed if no token present" do
    assert_raise Hourly.UnauthrorizedError, fn ->
      build_conn()
      |> Hourly.Plugs.Authenticate.call(%{})
    end
  end

  test "user not passed if wrong token present" do
    assert_raise Hourly.UnauthrorizedError, fn ->
      build_conn()
      |> put_req_header("authorization", "Bearer wrong")
      |> Hourly.Plugs.Authenticate.call(%{})
    end
  end
end
