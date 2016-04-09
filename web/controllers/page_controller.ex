defmodule VelocitasIdentity.PageController do
  use VelocitasIdentity.Web, :controller

  def index(conn, _params) do
    token = Guardian.Plug.current_token(conn)
    user = Guardian.Plug.current_resource(conn)
    Apex.ap token
    Apex.ap user
    assign(conn, :user, user)
    render conn, "index.html"
  end
end
