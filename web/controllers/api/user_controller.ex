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
    real_token = "Bearer #{Application.get_env(:velocitas_identity, :api_auth).bearer_token}"

    auth_token_value = conn.req_headers
    |> Enum.filter(fn(header_tuple) -> elem(header_tuple, 0) == "authorization" end)
    |> Enum.map(fn(auth_header) -> elem(auth_header, 1) end)

    case auth_token_value do
      [^real_token] -> conn
      _ -> conn |> send_resp(401, "Unauthorized") |> halt
    end
  end

  # plug Guardian.Plug.EnsureAuthenticated, handler: VelocitasIdentity.AuthErrorHandler
end
