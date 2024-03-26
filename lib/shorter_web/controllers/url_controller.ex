defmodule ShorterWeb.UrlController do
  use ShorterWeb, :controller
  alias ShorterWeb.Urls
  alias ShorterWeb.Url


  @doc"""
  Renders a form where users can paste in a URL
  """
  def new(conn, _params) do
    render(conn, "index.html")
  end


  @doc"""
  Processes user submission to return the short URL if the input URL is valid.
  """
  def create(conn, %{"url" => %{"url" => url_params}}) do
      case Urls.shorten_url(url_params) do
        {:ok, slug } ->
          conn
          |> put_flash(:info, "Successfully created a short URL!")
          |> redirect(to: Routes.url_path(conn, :index))

        {:error, _changeset} ->
          conn
          |> put_flash(:error, "Invalid URL!")
          |> redirect(to: Routes.url_path(conn, :index))
      end
  end

  @doc"""
  Redirects to the original URL when user inputs the shortened URL

  If the slug is valid, increments clicks and redirects to original URL
  If invalid, renders a 404 page
  """
  def show(conn, %{"slug" => slug}) do
    case Urls.get_url_by_slug(slug) do
      {:ok, original_url} ->
        Urls.inc_click_count(slug)
        redirect(conn, external: original_url)

      {:error, _msg} ->
        conn
        |> put_status(:not_found)
        |> put_view(ShorterWeb.ErrorView)
      |> render("404.html")
    end
  end


end
