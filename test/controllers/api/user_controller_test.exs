defmodule VelocitasIdentity.Api.UserControllerTest do
  use VelocitasIdentity.ConnCase

  alias VelocitasIdentity.User

  test "rejects unauthorized requests with a 401", %{conn: conn} do
    conn = get conn, api_user_path(conn, :index)
    assert conn.status == 401
  end

  test "rejects malformed bearer token with 401", %{conn: conn} do
    conn = conn |> put_req_header("authorization", "Bearer asdf")
    conn = get conn, api_user_path(conn, :index)
    assert conn.status == 401
  end

  test "returns list of users", %{ conn: conn } do
    real_token = Application.get_env(:api_auth, :bearer_token)
    conn = conn |> put_req_header("authorization", "Bearer #{real_token}")
    email = "hello@example.com"
    name = "andrew"

    Repo.insert(%User{email: email, name: name})

    conn = get conn, api_user_path(conn, :index)
    assert conn.status == 200
    assert conn.resp_body != ''
  end
end
