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
        {:ok, basic_info(auth)}
        #{:ok, 'sweet I exist'}
        #update_user(auth, repo)
    end
  end

  defp create_user_from(auth, repo) do
    %{id: facebook_user_id} = basic_info(auth)
    repo.transaction fn ->
      case repo.insert(%User{facebook_user_id: facebook_user_id}) do
        {:ok, user} -> user
        {:error, reason} -> reason
      end
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
