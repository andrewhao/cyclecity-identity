defmodule VelocitasIdentity.Endpoint do
  use Phoenix.Endpoint, otp_app: :velocitas_identity

  socket "/socket", VelocitasIdentity.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :velocitas_identity, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: PlugRailsCookieSessionStore,
    key: "_cyclecity_session",
    #secure: true,
    encrypt: true,
    domain: Application.get_env(:velocitas_identity, :session_cookie_auth).domain,
    signing_salt: Application.get_env(:velocitas_identity, :session_cookie_auth).signing_salt || "encrypted cookie",
    encryption_salt: Application.get_env(:velocitas_identity, :session_cookie_auth).encryption_salt || "signed encrypted cookie",
    key_iterations: 1000,
    key_length: 64,
    key_digest: :sha,
    serializer: Poison

  plug VelocitasIdentity.Router
end
