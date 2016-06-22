defmodule VelocitasIdentity.Api.UserController do
  use VelocitasIdentity.Web, :controller

  import Plug.Conn

  alias VelocitasIdentity.User

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  plug :authenticate_api_request

  defp authenticate_api_request(conn, _) do
    Apex.ap "Incoming auth"
    Apex.ap conn.req_headers
    real_token = "Bearer #{Application.get_env(:api_auth, :bearer_token)}"
    Apex.ap "real token: #{real_token}"
    case conn.req_headers do
      [ { "authorization", token } ] ->
        Apex.ap "token: #{token}"
        case token do
          real_token ->
            Apex.ap token
            conn
          _ -> conn |> send_resp(401, "Unauthorized") |> halt
        end
      _ -> conn |> send_resp(401, "Unauthorized") |> halt
    end
  end

  # plug Guardian.Plug.EnsureAuthenticated, handler: VelocitasIdentity.AuthErrorHandler
end
