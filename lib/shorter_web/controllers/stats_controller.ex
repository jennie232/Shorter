defmodule ShorterWeb.StatsController do
  @moduledoc """
  Controller for displaying the stats page.
  """
  use ShorterWeb, :controller
  alias Shorter.Urls

  @doc """
  Renders all URL records on the index page.
  """
  @spec index(Conn.t(), map()) :: Conn.t()
  def index(conn, _params) do
    urls = Urls.list_urls()
    render(conn, :index, urls: urls)
  end

  @doc """
  Exports all URL records as a CSV file and automatically initiates the download.
  """
  @spec export(Conn.t(), map()) :: Conn.t()
  def export(conn, _params) do
    urls = Urls.list_urls()
    csv_data = generate_csv(urls)

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"url_stats.csv\"")
    |> send_resp(200, csv_data)
  end

  @doc false
  defp generate_csv(urls) do
    headers = ["Original URL", "Short URL", "Clicks", "Date"]

    rows =
      Enum.map(urls, fn url ->
        [
          url.original_url,
          "#{Application.fetch_env!(:shorter, :base_url)}/#{url.slug}",
          url.clicks,
          url.inserted_at |> NaiveDateTime.to_date() |> Date.to_string()
        ]
      end)

    (rows ++ [headers])
    |> Enum.reverse()
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string()
  end
end
