defmodule Shorter.Urls do
  @moduledoc """
  Context module for managing URLs.
  """

  alias Shorter.Repo
  alias Shorter.Url

  @doc """
  Returns a list of all Url records including:
  - Shortened url
  - Corresponding original url
  - # of shortened url visits
  """
  @spec list_urls() :: [Url.t()]
  def list_urls do
    Repo.all(Url)
  end

  @doc """
  Retrieves the Url record associated with the slug if it exists.
  """
  @spec get_url_by_slug(String.t()) :: {:ok, Url.t()} | {:error, String.t()}
  def get_url_by_slug(slug) do
    case Repo.get_by(Url, slug: slug) do
      %Url{} = url -> {:ok, url}
      nil -> {:error, "URL not found"}
    end
  end

  @doc """
  Shortens the original URL.
  If the original URL already exists, returns the existing Url record.
  """
  @spec shorten_url(map()) :: {:ok, Url.t()} | {:error, Ecto.Changeset.t()}
  def shorten_url(%{"original_url" => original_url} = attrs) do
    case Repo.get_by(Url, original_url: original_url) do
      nil ->
        %Url{}
        |> Url.changeset(attrs)
        |> Repo.insert()

      %Url{} = url ->
        {:ok, url}
    end
  end

  @doc """
  Increments clicks when the short URL is used.
  """
  @spec inc_click_count(Url.t()) :: {:ok, Url.t()} | {:error, Ecto.Changeset.t()}
  def inc_click_count(%Url{} = url) do
    url
    |> Url.changeset(%{clicks: url.clicks + 1})
    |> Repo.update()
  end
end
