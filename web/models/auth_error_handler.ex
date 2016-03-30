defmodule VelocitasIdentity.AuthErrorHandler do
  use VelocitasIdentity.Web, :controller
  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Admin authentication required")
    |> redirect(to: page_path(conn, :index))
  end
end
