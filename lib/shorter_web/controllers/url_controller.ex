defmodule ShorterWeb.UrlController do
  @moduledoc """
  Controller for handling the URL shortening.
  """

  use ShorterWeb, :controller

  alias Shorter.Urls
  alias Shorter.Schemas.Url
  alias Shorter.Services.ShortenUrl

  @doc """
  Renders the form that allows user input of the original URL.
  """
  @spec new(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def new(conn, _params) do
    changeset = Urls.change_url(%Url{})
    render(conn, :new, changeset: changeset, original_url: nil, slug: nil)
  end

  @doc """
  Handles the form submissions and displays the shortened URL and original URL.
  """
  @spec new(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"url" => url_params}) do
    case ShortenUrl.shorten_url(url_params) do
      {:ok, slug} ->
        conn
        |> assign(:original_url, url_params["original_url"])
        |> assign(:slug, slug)
        |> render(:new, changeset: Urls.change_url(%Url{}))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:original_url, url_params["original_url"])
        |> assign(:slug, nil)
        |> render(:new, changeset: changeset)
    end
  end
end
