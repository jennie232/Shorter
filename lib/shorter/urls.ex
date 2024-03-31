defmodule Shorter.Urls do
  @moduledoc """
  Urls context for managing/interacting with URLs.
  """

  import Ecto.Query
  alias Shorter.Repo
  alias Shorter.Schemas.Url

  @doc """
  Returns a list of all URL records
  """
  @spec list_urls() :: [Url.t()]
  def list_urls do
    Repo.all(Url)
  end

  @doc """
  Retrieves the URL record associated with the slug if it exists and increments the click count.
  """
  @spec get_url_by_slug_and_increment_clicks(String.t()) :: {:ok, Url.t()} | {:error, :not_found}
  def get_url_by_slug_and_increment_clicks(slug) do
    case get_url_by_slug(slug) do
      {:ok, url} ->
        inc_click_count(url)

        updated_url = Repo.get(Url, url.id)
        {:ok, updated_url}

      {:error, :not_found} = error ->
        error
    end
  end

  @doc """
  Retrieves the URL record associated with the original URL if it exists
  """
  @spec get_url_by_original(String.t()) :: {:ok, Url.t()} | {:error, :not_found}
  def get_url_by_original(original_url) do
    case Repo.get_by(Url, original_url: original_url) do
      %Url{} = url -> {:ok, url}
      nil -> {:error, :not_found}
    end
  end

  @doc """
  Creates a new URL record
  """
  @spec create_url(map()) :: {:ok, Url.t()} | {:error, Ecto.Changeset.t()}
  def create_url(attrs) do
    %Url{}
    |> Url.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates the changeset for validating the URL record
  """
  @spec change_url(Url.t()) :: Ecto.Changeset.t()
  def change_url(%Url{} = url) do
    Url.changeset(url, %{})
  end

  defp get_url_by_slug(slug) do
    case Repo.get_by(Url, slug: slug) do
      %Url{} = url -> {:ok, url}
      nil -> {:error, :not_found}
    end
  end

  defp inc_click_count(%Url{id: id}) do
    from(u in Url, where: u.id == ^id, update: [inc: [clicks: 1]])
    |> Repo.update_all([])
  end
end
