defmodule ShorterWeb.RedirectController do
  use ShorterWeb, :controller

  alias Shorter.Urls

  @doc """
  Redirects to the original URL when user inputs short URL
  """
  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"slug" => slug}) do
    case Urls.get_url_by_slug(slug) do
      {:ok, url} ->
        conn
        |> redirect(external: url.original_url)
        |> halt()

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(ShorterWeb.ErrorHTML)
        |> render(:"404")
        |> halt()
    end
  end
end
