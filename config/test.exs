use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hourly, Hourly.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :junit_formatter,
  report_file: "test-results.xml",
  report_dir: "tmp",
  print_report_file: true

# Configure your database
config :hourly, Hourly.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "hourly_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
