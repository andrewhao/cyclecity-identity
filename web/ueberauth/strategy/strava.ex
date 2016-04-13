defmodule Ueberauth.Strategy.Strava do
  @moduledoc """
  Strava Strategy for Überauth.
  """

  use Ueberauth.Strategy, default_scope: "public",
                          uid_field: :id
  alias Ueberauth.Auth.Info
  alias Ueberauth.Auth.Credentials
  alias Ueberauth.Auth.Extra

  @doc """
  Handles initial request for Strava authentication.
  """
  def handle_request!(conn) do

    authorize_url = conn.params
      |> maybe_replace_param(conn, "scope", :default_scope)
      |> Enum.map(fn {k,v} -> {String.to_existing_atom(k), v} end)
      |> Keyword.put(:redirect_uri, callback_url(conn))
      |> Ueberauth.Strategy.Strava.OAuth.authorize_url!

    redirect!(conn, authorize_url)
  end

  @doc """
  Handles the callback from Strava.
  """
  def handle_callback!(%Plug.Conn{params: %{"code" => code}} = conn) do
    opts = [redirect_uri: callback_url(conn)]
    token = Ueberauth.Strategy.Strava.OAuth.get_token!([code: code], opts)

    if token.access_token == nil do
      err = token.other_params["error"]
      desc = token.other_params["error_description"]
      set_errors!(conn, [error(err, desc)])
    else
      fetch_athlete(conn, token)
    end
  end

  @doc false
  def handle_callback!(conn) do
    set_errors!(conn, [error("missing_code", "No code received")])
  end

  @doc false
  def handle_cleanup!(conn) do
    conn
    |> put_private(:strava_athlete, nil)
    |> put_private(:strava_token, nil)
  end

  @doc """
  Fetches the uid field from the response.
  """
  def uid(conn) do
    uid_field =
      conn
      |> option(:uid_field)
      |> to_string

    conn.private.strava_athlete[uid_field]
  end

  @doc """
  Includes the credentials from the Strava response.
  """
  def credentials(conn) do
    token = conn.private.strava_token
    scopes = token.other_params["scope"] || ""
    scopes = String.split(scopes, ",")

    %Credentials{
      expires: !!token.expires_at,
      expires_at: token.expires_at,
      scopes: scopes,
      token: token.access_token
    }
  end

  @doc """
  Fetches the fields to populate the info section of the
  `Ueberauth.Auth` struct.
  """
  def info(conn) do
    athlete = conn.private.strava_athlete

    %Info{
      first_name: athlete["firstname"],
      last_name: athlete["lastname"],
      email: athlete["email"],
      image: athlete["profile"],
    }
  end

  @doc """
  Stores the raw information (including the token) obtained from
  the Strava callback.
  """
  def extra(conn) do
    %Extra{
      raw_info: %{
        token: conn.private.strava_token,
        athlete: conn.private.strava_athlete
      }
    }
  end

  defp fetch_image(uid) do
    "http://graph.Strava.com/#{uid}/picture?type=square"
  end

  defp fetch_athlete(conn, token) do
    conn = put_private(conn, :strava_token, token)
    Apex.ap "fetching athlete"
    path = "/api/v3/athlete"
    case OAuth2.AccessToken.get(token, path) do
      {:ok, %OAuth2.Response{status_code: 401, body: _body}} ->
        set_errors!(conn, [error("token", "unauthorized")])
      {:ok, %OAuth2.Response{status_code: status_code, body: athlete}}
        when status_code in 200..399 ->
        put_private(conn, :strava_athlete, athlete)
      {:error, %OAuth2.Error{reason: reason}} ->
        set_errors!(conn, [error("OAuth2", reason)])
    end
  end

  defp query_params(conn, :profile) do
    %{"fields" => option(conn, :profile_fields)}
  end
  defp query_params(conn, :locale) do
    case option(conn, :locale) do
      nil -> %{}
      locale -> %{"locale" => locale}
    end
  end

  defp option(conn, key) do
    default = Dict.get(default_options, key)

    conn
    |> options
    |> Dict.get(key, default)
  end
  defp option(nil, conn, key), do: option(conn, key)
  defp option(value, _conn, _key), do: value

  defp maybe_replace_param(params, conn, name, config_key) do
    if params[name] do
      params
    else
      Map.put(
        params,
        name,
        option(params[name], conn, config_key)
      )
    end
  end
end
