defmodule ShorterWeb.StatsControllerTest do
  use ShorterWeb.ConnCase
  alias Shorter.Urls

  setup do
    Cachex.clear(:slug_cache)

    {:ok, url1} = Urls.create_url(%{original_url: "https://www.validurl.com", slug: "slug123"})
    {:ok, url2} = Urls.create_url(%{original_url: "https://www.validurl.org", slug: "slug1234"})

    {:ok, url1: url1, url2: url2}
  end

  describe "index" do
    test "renders the stats page with a list of the URL records", %{
      conn: conn,
      url1: url1,
      url2: url2
    } do
      conn = get(conn, "/stats")
      assert html_response(conn, 200) =~ "URL Shortener Stats"
      assert html_response(conn, 200) =~ url1.original_url
      assert html_response(conn, 200) =~ url2.original_url

      assert html_response(conn, 200) =~
               "#{Application.fetch_env!(:shorter, :base_url)}/#{url1.slug}"

      assert html_response(conn, 200) =~
               "#{Application.fetch_env!(:shorter, :base_url)}/#{url2.slug}"

      assert html_response(conn, 200) =~ "#{url1.clicks}"
      assert html_response(conn, 200) =~ "#{url2.clicks}"
    end
  end

  describe "export" do
    test "exports the URL records as a CSV file", %{conn: conn, url1: url1, url2: url2} do
      conn = get(conn, "/stats/export")
      assert conn.status == 200
      assert conn.resp_body =~ "Original URL,Short URL,Clicks,Date"
      assert conn.resp_body =~ url1.original_url
      assert conn.resp_body =~ url2.original_url
      assert conn.resp_body =~ "#{Application.fetch_env!(:shorter, :base_url)}/#{url1.slug}"
      assert conn.resp_body =~ "#{Application.fetch_env!(:shorter, :base_url)}/#{url2.slug}"

      assert conn.resp_body =~
               "0,#{url1.inserted_at |> NaiveDateTime.to_date() |> Date.to_string()}"

      assert conn.resp_body =~
               "0,#{url2.inserted_at |> NaiveDateTime.to_date() |> Date.to_string()}"
    end
  end
end
