defmodule Shorter.Services.ShortenUrl do
  @moduledoc """
  Service for shortening URLs.
  """
  alias Shorter.Schemas.Url
  alias Shorter.Urls


  @doc """
  Shortens the original URL by generating and caching the slug.


  If the original URL already exists in the db, returns the existing slug.
  Else, a unique slug is generated, cached, and returned.
  """
  @spec shorten_url(map()) :: {:ok, String.t()} | {:error, term()}
  def shorten_url(%{"original_url" => original_url} = attrs) do
    case Cachex.get(:slug_cache, original_url) do
      {:ok, slug} when is_binary(slug) ->
        {:ok, slug}

      _ ->
        handle_cache_miss(original_url, attrs)
    end
  end

  defp handle_cache_miss(original_url, attrs) do
    case Urls.get_url_by_original(original_url) do
      {:ok, %Url{slug: slug} = _url} ->
        cache_slug(original_url, slug)
        {:ok, slug}

      {:error, :not_found} ->
        create_and_cache_url(attrs)
    end
  end

  defp create_and_cache_url(attrs) do
    slug = generate_slug()

    attrs
    |> Map.put("slug", slug)
    |> Urls.create_url()
    |> case do
      {:ok, %Url{slug: ^slug} = url} ->
        cache_slug(url.original_url, slug)
        {:ok, slug}

      {:error, _} = error ->
        error
    end
  end

  @doc """
  Creates a unique slug using Nanoid of size 8. If the slug is not unique, generate another slug
  """
  @spec generate_slug() :: String.t()
  def generate_slug do
    slug = Nanoid.generate(8)
    attrs = %{original_url: "https://validurl.com", slug: slug}

    case Url.changeset(%Url{}, attrs) do
      %Ecto.Changeset{valid?: true} -> slug
      %Ecto.Changeset{valid?: false} -> generate_slug()
    end
  end

  defp cache_slug(original_url, slug) do
    Cachex.put(:slug_cache, original_url, slug, ttl: :timer.minutes(30))
  end
end
