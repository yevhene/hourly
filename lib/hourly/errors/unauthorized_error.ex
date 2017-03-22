defmodule Hourly.UnauthrorizedError do
  defexception message: "unauthorized", plug_status: 401
end
