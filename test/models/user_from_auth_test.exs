defmodule VelocitasIdentity.UserFromAuthTest do
  use VelocitasIdentity.ModelCase

  alias Ueberauth.Auth
  alias VelocitasIdentity.UserFromAuth
  alias VelocitasIdentity.User

  test "Strava creates a new user when one does not exist" do
    auth = %Auth{
      uid: 123,
      info: %{
        name: "Andrew Hao",
        email: "andrew@example.com",
        image: "image"
      },
      credentials: %{
        token: "token",
        expires: "expires",
        expires_at: "expires_at"
      },
      provider: :strava
    }
    result = UserFromAuth.find_or_create(auth, Repo)

    {:ok, user} = result
    assert user.strava_athlete_id == 123
    assert user.strava_access_token == "token"
    assert user.email == "andrew@example.com"
  end

  test "Strava finds and updatesw user when one exists" do
    auth = %Auth{
      uid: 123,
      info: %{
        name: "Andrew Hao",
        email: "andrew@example.com",
        image: "image"
      },
      credentials: %{
        token: "token",
        expires: "expires",
        expires_at: "expires_at"
      },
      provider: :strava
    }
    user = %User{
      name: "Andrew Hao",
      email: "oldemail@example.com",
      strava_athlete_id: 123,
      strava_access_token: "old_token"
    }
    Repo.insert(user)
    result = UserFromAuth.find_or_create(auth, Repo)

    {:ok, user} = result
    assert user.strava_athlete_id == 123
    assert user.strava_access_token == "token"
    assert user.email == "andrew@example.com"
  end
end
