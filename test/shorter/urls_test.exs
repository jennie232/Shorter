defmodule Shorter.UrlsTest do
  use Shorter.DataCase
  alias Shorter.Urls
  alias Shorter.Schemas.Url

  @valid_attrs %{"original_url" => "https://validurl.com", "slug" => "slug123"}
  @invalid_url "ht:/invalid"

  def url_fixture(attrs \\ %{}) do
    {:ok, url} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Urls.create_url()

    url
  end

  describe "list_urls/0" do
    test "returns all urls" do
      url_fixture()
      url_fixture(%{"original_url" => "https://example.org", "slug" => "def456"})

      assert length(Urls.list_urls()) == 2
    end
  end

  describe "get_url_by_slug/1" do
    test "returns the original url associated with the slug" do
      url = url_fixture()
      assert {:ok, original_url} = Urls.get_url_by_slug(@valid_attrs["slug"])
      assert original_url.id == url.id
    end

    test "returns error when the slug doesn't exist" do
      assert {:error, :not_found} = Urls.get_url_by_slug("invalid_slug")
    end
  end

  describe "get_url_by_original/1" do
    test "returns the URL record given the original URL" do
      url = url_fixture()
      assert {:ok, %Url{} = retrieved_url} = Urls.get_url_by_original(url.original_url)
      assert retrieved_url.id == url.id
      assert retrieved_url.slug == url.slug
    end

    test "returns error when original URL doesn't exist" do
      assert {:error, :not_found} = Urls.get_url_by_original(@invalid_url)
    end
  end

  describe "create_url/1" do
    test "creates a URL record" do
      assert {:ok, %Url{} = retrieved_url} = Urls.create_url(@valid_attrs)
      assert retrieved_url.original_url == @valid_attrs["original_url"]
      assert retrieved_url.slug == @valid_attrs["slug"]
    end

    test "returns error when original_url is invalid" do
      assert {:error, %Ecto.Changeset{}} = Urls.create_url(%{"original_url" => @invalid_url})
    end

    test "returns error when slug is not unique" do
      url_fixture(%{"slug" => "duplicate"})
      attrs = %{"original_url" => "https://example.com", "slug" => "duplicate"}
      assert {:error, %Ecto.Changeset{}} = Urls.create_url(attrs)
    end
  end

  describe "inc_click_count/1" do
    test "increments the click count of the URL record" do
      {:ok, url} = Urls.create_url(@valid_attrs)

      assert {:ok, :increment} = Urls.inc_click_count(url.id)

      assert {:ok, %Url{clicks: 1}} = Urls.get_url_by_original(@valid_attrs["original_url"])
    end

    test "returns the accurate click count" do
       {:ok, url} = Urls.create_url(@valid_attrs)

       Urls.inc_click_count(url.id)
       Urls.inc_click_count(url.id)

       assert {:ok, %Url{clicks: 2}} = Urls.get_url_by_original(@valid_attrs["original_url"])
    end
  end
end
