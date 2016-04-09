defmodule VelocitasIdentity.PageView do
  use VelocitasIdentity.Web, :view

  def logged_in?(conn) do
    conn.assigns[:user] !== nil
  end

  def username(conn) do
    conn.assigns[:user].name
  end
end
