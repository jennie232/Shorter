defmodule ShorterWeb.RedirectController do
  use ShorterWeb, :controller

  alias Shorter.Urls

  @doc """
  Redirects to the original URL when user inputs short URL
  """
  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"slug" => slug}) do
    case Urls.get_url_by_slug_and_increment_clicks(slug) do
      {:ok, url} ->
        conn
        |> redirect(external: url.original_url)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(ShorterWeb.ErrorHTML)
        |> render(:"404")
    end
  end
end
