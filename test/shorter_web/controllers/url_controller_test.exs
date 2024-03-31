defmodule ShorterWeb.UrlControllerTest do
  use ShorterWeb.ConnCase

  alias Shorter.Urls
  alias Shorter.Schemas.Url

  @valid_attrs %{"original_url" => "https://validurl.com"}
  @invalid_attrs %{"original_url" => "invalid"}


  describe "new short URL" do
    test "renders the URL form", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "Shorten your URLs"
      assert html_response(conn, 200) =~ "Enter the URL to shorten"
    end
  end

  describe "create short URL" do
    test "renders the short URL when data is valid and successfully created", %{conn: conn} do
      conn = post(conn, "/", %{"url" => @valid_attrs})
      assert html_response(conn, 200) =~ "Shorten your URLs"
      assert html_response(conn, 200) =~ @valid_attrs["original_url"]
      assert conn.assigns[:slug] != nil
    end

    test "renders existing short URL when original URL has already been inputted", %{conn: conn} do
      {:ok, url} =
        Urls.create_url(%{"original_url" => @valid_attrs["original_url"], "slug" => "slug123"})

      conn = post(conn, "/", %{"url" => @valid_attrs})
      assert html_response(conn, 200) =~ "Shorten your URLs"
      assert html_response(conn, 200) =~ @valid_attrs["original_url"]
      assert conn.assigns[:slug] == "slug123s"
    end

    test "renders errors when original URL is invalid", %{conn: conn} do
      conn = post(conn, "/", %{"url" => @invalid_attrs})
      assert html_response(conn, 200) =~ "Please enter a valid URL"
      assert html_response(conn, 200) =~ "Error"
      assert conn.assigns[:slug] == nil
    end

    test "renders errors when there's no input", %{conn: conn} do
      conn = post(conn, "/", %{"url" => %{"original_url" => ""}})
      assert html_response(conn, 200) =~ "Please enter a valid URL"
      assert html_response(conn, 200) =~ "Error"
      assert html_response(conn, 200) =~ "can't be blank"
      assert conn.assigns[:original_url] == nil
      assert conn.assigns[:slug] == nil
    end
  end
end
