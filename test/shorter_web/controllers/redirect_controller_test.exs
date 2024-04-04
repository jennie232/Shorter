defmodule ShorterWeb.RedirectControllerTest do
  use ShorterWeb.ConnCase

  alias Shorter.Urls

  setup do
    Cachex.clear(:slug_cache)

    {:ok, url1} = Urls.create_url(%{original_url: "https://www.validurl.com", slug: "slug123"})
    {:ok, url2} = Urls.create_url(%{original_url: "https://www.validurl.org", slug: "slug1234"})

    {:ok, url1: url1, url2: url2}
  end

  describe "show original URL" do
    test "redirects to the original URL and increments click count when a valid slug is provided",
         %{conn: conn, url1: url1} do
      conn = get(conn, "/#{url1.slug}")
      assert redirected_to(conn) == url1.original_url
      assert conn.status == 302

      Process.sleep(100)

      {:ok, updated_url} = Urls.get_url_by_slug(url1.slug)
      assert updated_url.clicks == 1

      get(conn, "/#{url1.slug}")

      Process.sleep(100)
      {:ok, updated_url} = Urls.get_url_by_slug(url1.slug)
      assert updated_url.clicks == 2
    end

    test "returns a 404 error when an invalid slug is provided", %{conn: conn} do
      conn = get(conn, ~p"/invalid-slug")
      assert conn.status == 404
    end
  end
end
