defmodule Shorter.Url do
  @moduledoc """
  Defines the schema and changeset for URLs

  """
  use Ecto.Schema
  import Ecto.Changeset

  @regex_check ~r/^https?:\/\/[^\s\/$.?#].[^\s]*$/
  @invalid_url_msg "Invalid URL"

  schema "urls" do
    field :original_url, :string
    field :slug, :string
    field :clicks, :integer, default: 0
    timestamps()
  end

  def changeset(url, attrs) do
    url
    |> cast(attrs,[:original_url])
    |> validate_required([:original_url])
    |> validate_format(:original_url, @regex_check, message: @invalid_url_msg)
    |> put_slug()
    |> unique_constraint(:slug)
  end

  defp put_slug(changeset) do
    case changeset.valid? do
      true ->
        slug = get_field(changeset, :slug) || Ecto.UUID.generate()
        put_change(changeset, :slug, slug)
      false ->
        changeset
      end
    end
  end
