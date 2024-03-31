defmodule Shorter.Schemas.Url do
  @moduledoc """
  The URL Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer,
          original_url: String.t(),
          slug: String.t(),
          clicks: integer,
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @duplicate_slug_msg "Slug already exists"
  @valid_schemes ["http", "https"]
  @valid_hosts [~r/\A[\w-]+(?:\.[\w-]+)+\z/]

  schema "urls" do
    field :original_url, :string
    field :slug, :string
    field :clicks, :integer, default: 0
    timestamps()
  end

  @doc false
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:original_url, :slug])
    |> validate_required([:original_url, :slug])
    |> validate_url(:original_url)
    |> unique_constraint(:slug, message: @duplicate_slug_msg)
  end

  defp validate_url(changeset, field) do
    validate_change(changeset, field, fn _, original_url ->
      case URI.new(original_url) do
        {:ok, url} ->
          cond do
            is_nil(url.scheme) || url.scheme == "" ->
              [{field, "URL scheme is missing"}]

            url.scheme not in @valid_schemes ->
              [{field, "URL scheme must be 'http' or 'https'"}]

            not valid_host?(url.host) ->
              [{field, "URL does not have a valid host"}]

            true ->
              []
          end

        {:error, _reason} ->
          [{field, "Invalid URL format"}]
      end
    end)
  end

  defp valid_host?(host) when is_nil(host), do: false

  defp valid_host?(host) do
    Enum.any?(@valid_hosts, fn validator -> Regex.match?(validator, host) end)
  end
end
