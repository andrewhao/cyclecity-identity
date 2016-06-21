defmodule VelocitasIdentity.PageControllerTest do
  use VelocitasIdentity.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Cyclecity"
  end
end
