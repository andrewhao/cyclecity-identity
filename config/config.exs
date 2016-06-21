# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

IO.puts System.get_env("PATH")
IO.puts System.get_env("DATABASE_URL")
IO.puts System.get_env("PORT")
IO.puts System.get_env("FACEBOOK_CLIENT_ID")
IO.puts System.get_env("FACEBOOK_CLIENT_SECRET")
IO.puts System.get_env("STRAVA_CLIENT_ID")
IO.puts System.get_env("STRAVA_CLIENT_SECRET")

# Configures the endpoint
config :velocitas_identity, VelocitasIdentity.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: VelocitasIdentity.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    facebook: {Ueberauth.Strategy.Facebook, []},
    strava: {Ueberauth.Strategy.Strava, [
      default_scope: "view_private,write"
    ]}
  ]

config :ueberauth, Ueberauth.Strategy.Strava.OAuth,
  client_id: System.get_env("STRAVA_CLIENT_ID"),
  client_secret: System.get_env("STRAVA_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: System.get_env("FACEBOOK_CLIENT_ID"),
  client_secret: System.get_env("FACEBOOK_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Auth framework.
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "VelocitasIdentity",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: System.get_env("SECRET_KEY_BASE"),
  serializer: VelocitasIdentity.GuardianSerializer

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
