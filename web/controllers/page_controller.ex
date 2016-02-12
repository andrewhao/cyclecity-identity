defmodule VelocitasIdentity.PageController do
  use VelocitasIdentity.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
