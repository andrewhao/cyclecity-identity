defmodule VelocitasIdentity.Repo.Migrations.AddFacebookFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :facebook_user_id, :string
      add :facebook_access_token, :string
    end
  end
end
