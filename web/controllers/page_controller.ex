defmodule VelocitasIdentity.PageController do
  use VelocitasIdentity.Web, :controller

  def index(conn, _params) do
    token = Guardian.Plug.current_token(conn)
    user = Guardian.Plug.current_resource(conn)
    Apex.ap(user)
    render conn, "index.html", current_user: user
  end
end
