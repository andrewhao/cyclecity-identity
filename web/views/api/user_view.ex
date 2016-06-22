defmodule VelocitasIdentity.Api.UserView do
  use VelocitasIdentity.Web, :view

  def render("index.json", %{users: users}) do
    %{users: render_many(users, VelocitasIdentity.Api.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{ id: user.id, name: user.name, strava_access_token: user.strava_access_token, email: user.email }
  end
end
