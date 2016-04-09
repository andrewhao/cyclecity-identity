defmodule VelocitasIdentity.User do
  use VelocitasIdentity.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :strava_access_token, :string
    field :strava_athlete_id, :integer
    field :facebook_access_token, :string
    field :facebook_user_id, :string

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(name email strava_access_token strava_athlete_id facebook_user_id facebook_access_token)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
