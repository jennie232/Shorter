defmodule Shorter.Services.UrlsTest do
  use Shorter.DataCase
  alias Shorter.Urls
  alias Shorter.Schemas.Url
  alias Shorter.Services.ShortenUrl

  @valid_attrs "https://validurl.com"
  @invalid_attrs "ht:/invalid"
  setup do
    Cachex.clear(:slug_cache)
    :ok
  end

  describe "shorten_url/1" do
    test "returns the existing slug if original URL exists in the cache" do
      slug = ShortenUrl.generate_slug()
      Cachex.put(:slug_cache, @valid_attrs, slug)

      attrs = %{"original_url" => @valid_attrs}

      assert {:ok, cached_slug} = ShortenUrl.shorten_url(attrs)
      assert cached_slug == slug
    end

    test "returns slug if the original URL exists in the database but not the slug" do
      attrs = %{"original_url" => @valid_attrs, "slug" => ShortenUrl.generate_slug()}

      {:ok, url} = Urls.create_url(attrs)

      assert {:ok, returned_slug} = ShortenUrl.shorten_url(%{"original_url" => @valid_attrs})
      assert returned_slug == url.slug
      assert {:ok, url.slug} == Cachex.get(:slug_cache, @valid_attrs)
    end

    test "generates a slug for the new original URL and both saves the URL record and caches the slug" do
      original_url = @valid_attrs
      assert {:ok, slug} = ShortenUrl.shorten_url(%{"original_url" => @valid_attrs})
      assert is_binary(slug)
      assert byte_size(slug) == 8

      assert {:ok, %Url{original_url: ^original_url, slug: ^slug}} =
               Urls.get_url_by_original(@valid_attrs)
    end

    test "returns an error if URL cannot be shortened and nil if it cannot be retrieved from the cache" do
      assert {:error, %Ecto.Changeset{}} =
               ShortenUrl.shorten_url(%{"original_url" => @invalid_attrs})
    end
  end

  describe "generate_slug/0" do
    test "generates a unique slug of size 8" do
      slug = ShortenUrl.generate_slug()
      assert is_binary(slug)
      assert byte_size(slug) == 8
    end
  end
end
