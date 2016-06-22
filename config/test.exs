use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :velocitas_identity, VelocitasIdentity.Endpoint,
  http: [port: 4001],
  server: false,
  secret_key_base: 'testsecret'

# Print only warnings and errors during test
config :logger, level: :warn

config :velocitas_identity, :api_auth, %{
  bearer_token: 'test-token-123xyz'
}

# Configure your database
config :velocitas_identity, VelocitasIdentity.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "velocitas_identity_test",
  hostname: "localhost",
  port: System.get_env("PGPORT") || 5432,
  pool: Ecto.Adapters.SQL.Sandbox
