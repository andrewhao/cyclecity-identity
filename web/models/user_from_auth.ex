defmodule UserFromAuth do
  @moduledoc """
  Retrieve the user information from an auth request
  """

  alias VelocitasIdentity.User
  alias Ueberauth.Auth

  def find_or_create(%Auth{} = auth, repo) do
    case find_user(auth, repo) do
      {:error, :not_found} ->
        {:ok, create_user_from(auth, repo)}
      user ->
        {:ok, update_user(auth, user, repo)}
    end
  end

  defp create_user_from(auth, repo) do
    %{id: facebook_user_id, name: name} = basic_info(auth)
    %{token: token} = credentials(auth)
    repo.transaction fn ->
      case repo.insert(%User{
        name: name,
        facebook_user_id: facebook_user_id,
        facebook_access_token: token
      }) do
        {:ok, user} -> user
        {:error, reason} -> reason
      end
    end
  end

  defp update_user(auth, user, repo) do
    %{token: token} = credentials(auth)
    %{name: name} = basic_info(auth)
    Apex.ap(token)
    changeset = User.changeset(user, %{name: name, facebook_access_token: token})
    Apex.ap(changeset)
    case repo.update(changeset) do
      {:ok, user} -> user
      {:error, changeset} -> changeset
    end
  end

  defp find_user(auth, repo) do
    %{id: fb_user_id} = basic_info(auth)
    case repo.get_by(User, facebook_user_id: fb_user_id) do
      nil -> {:error, :not_found}
      user -> user
    end
  end

  defp basic_info(auth) do
    %{id: auth.uid, name: name_from_auth(auth), avatar: auth.info.image}
  end

  defp credentials(auth) do
    credentials = auth.credentials
    %{token: credentials.token,
      expires: credentials.expires,
      expires_at: credentials.expires_at}
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name = [auth.info.first_name, auth.info.last_name]
      |> Enum.filter(&(&1 != nil and &1 != ""))

      cond do
        length(name) == 0 -> auth.info.nickname
        true -> Enum.join(name, " ")
      end
    end
  end
end
