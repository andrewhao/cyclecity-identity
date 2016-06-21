defmodule VelocitasIdentity.UserTest do
  use VelocitasIdentity.ModelCase

  alias VelocitasIdentity.User

  @valid_attrs %{email: "some content", name: "some content", strava_access_token: "some content", strava_athlete_id: 42}
  @invalid_attrs %{name: 1234}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
