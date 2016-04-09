defmodule VelocitasIdentity.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :strava_access_token, :string
      add :strava_athlete_id, :integer

      timestamps
    end

  end
end
