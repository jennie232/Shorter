defmodule Shorter.Url do
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

  @regex_check ~r/^https?:\/\/[^\s\/$.?#].[^\s]*$/
  @invalid_url_msg "Invalid URL"
  @duplicate_slug_msg "Slug already exists"

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
    |> cast(attrs,[:original_url])
    |> validate_required([:original_url])
    |> validate_format(:original_url, @regex_check, message: @invalid_url_msg)
    |> put_slug()
    |> unique_constraint(:slug, message: @duplicate_slug_msg)
  end


  defp put_slug(changeset) do
    slug = Ecto.UUID.generate()
    put_change(changeset, :slug, slug)
  end
