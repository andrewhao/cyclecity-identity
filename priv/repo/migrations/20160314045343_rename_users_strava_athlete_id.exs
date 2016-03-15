defmodule VelocitasIdentity.Repo.Migrations.RenameUsersStravaAthleteId do
  use Ecto.Migration

  def up do
    rename table(:users), :strava_athlete_id, to: :strava_athlete_id
  end

  def down do
    rename table(:users), :strava_athlete_id, to: :strava_athlete_id
  end
end
