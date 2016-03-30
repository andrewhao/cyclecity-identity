defmodule VelocitasIdentity.PageController do
  use VelocitasIdentity.Web, :controller

  def index(conn, _params) do
    Apex.ap "test"
    Apex.ap Guardian.Plug.current_token(conn)
    render conn, "index.html"
  end
end
