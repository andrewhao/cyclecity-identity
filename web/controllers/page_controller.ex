defmodule VelocitasIdentity.PageController do
  use VelocitasIdentity.Web, :controller
  use Timex

  def index(conn, _params) do

    {:ok, date} = Timex.format(DateTime.now, "{ISO:Extended}")
    Apex.ap get_session(conn, :web_message)
    Apex.ap get_session(conn, :session_id)
    Apex.ap get_session(conn, :api_message)
    Apex.ap get_session(conn, :current_user)
    conn = put_session(conn, :web_message, "Web received: #{date}")

    user = Guardian.Plug.current_resource(conn)
    render conn, "index.html", current_user: user
  end
end
