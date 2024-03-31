defmodule Shorter.UrlsTest do
  use Shorter.DataCase
  alias Shorter.Urls
  alias Shorter.Schemas.Url

  @valid_attrs %{"original_url" => "https://validurl.com", "slug" => "slug123"}
  @invalid_url "ht:/invalid"

  setup do
    {:ok, url: url_fixture()}
  end

  def url_fixture(attrs \\ %{}) do
    {:ok, url} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Urls.create_url()

    url
  end

  describe "list_urls/0" do
    test "returns all urls" do
      url_fixture(%{"original_url" => "https://validurl.org", "slug" => "slug1234"})
      assert length(Urls.list_urls()) == 2
    end
  end

  describe "get_url_by_slug_and_increment_clicks/1" do
    test "returns the original url associated with the slug and increments the click count", %{
      url: url
    } do
      assert {:ok, retrieved_url} = Urls.get_url_by_slug_and_increment_clicks(url.slug)
      assert retrieved_url.id == url.id
      assert retrieved_url.clicks == 1
    end

    test "returns error when the slug doesn't exist" do
      assert {:error, :not_found} = Urls.get_url_by_slug_and_increment_clicks("invalid_slug")
    end
  end

  describe "get_url_by_original/1" do
    test "returns the URL record given the original URL", %{url: url} do
      assert {:ok, retrieved_url} = Urls.get_url_by_original(url.original_url)
      assert retrieved_url.id == url.id
      assert retrieved_url.slug == url.slug
    end

    test "returns error when original URL doesn't exist" do
      assert {:error, :not_found} = Urls.get_url_by_original(@invalid_url)
    end
  end

  describe "create_url/1" do
    test "creates a URL record" do
      assert {:ok, %Url{} = retrieved_url} =
               Urls.create_url(%{"original_url" => "https://validurl.org", "slug" => "slug1234"})

      assert retrieved_url.original_url == "https://validurl.org"
      assert retrieved_url.slug == "slug1234"
    end

    test "returns error when original_url is invalid" do
      assert {:error, %Ecto.Changeset{}} = Urls.create_url(%{"original_url" => @invalid_url})
    end

    test "returns error when slug is not unique", %{url: url} do
      assert {:error, %Ecto.Changeset{}} = Urls.create_url(%{"original_url" => "https://validurl.org", "slug" => url.slug})
    end
  end
end
