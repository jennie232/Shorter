defmodule Shorter.Schemas.UrlTest do
  use ExUnit.Case
  use Shorter.DataCase
  import Ecto.Changeset
  alias Shorter.Schemas.Url

  describe "URL validations" do
    @valid_attrs %{original_url: "https://validurl.com", slug: "slug123"}
    @invalid_attrs %{original_url: "ht://invalidurl", slug: nil}

    test "with valid attributes" do
      changeset = Url.changeset(%Url{}, @valid_attrs)
      assert changeset.valid?
    end

    test "is invalid if scheme is other than http/https" do
      changeset = Url.changeset(%Url{}, %{@invalid_attrs | slug: "slug123"})
      refute changeset.valid?
      assert errors_on(changeset) == %{original_url: ["URL scheme must be 'http' or 'https'"]}
    end

    test "is invalid if scheme is missing" do
      changeset = Url.changeset(%Url{}, %{@valid_attrs | original_url: "validurl.com"})
      refute changeset.valid?
      assert errors_on(changeset) == %{original_url: ["URL scheme is missing"]}
    end

    test "is invalid if URL does not have host" do
      changeset = Url.changeset(%Url{}, %{@valid_attrs | original_url: "https://"})
      refute changeset.valid?
      assert errors_on(changeset) == %{original_url: ["URL does not have a valid host"]}
    end

    test "is invalid if URL does not have a valid domain extension" do
      changeset = Url.changeset(%Url{}, %{@valid_attrs | original_url: "https://invalid"})
      refute changeset.valid?
      assert errors_on(changeset) == %{original_url: ["URL does not have a valid host"]}
    end

    test "is invalid if no original URL as input" do
      changeset = Url.changeset(%Url{}, %{})
      refute changeset.valid?
      assert errors_on(changeset) == %{original_url: ["can't be blank"], slug: ["can't be blank"]}
    end

    test "is invalid if slug is nil" do
      changeset = Url.changeset(%Url{}, %{@valid_attrs | slug: nil})
      refute changeset.valid?
      assert errors_on(changeset) == %{slug: ["can't be blank"]}
    end

    test "is invalid if slug is empty" do
      changeset = Url.changeset(%Url{}, %{@valid_attrs | slug: ""})
      refute changeset.valid?
      assert errors_on(changeset) == %{slug: ["can't be blank"]}
    end

    test "is invalid with duplicate slug" do
      # Insert a URL with the same slug
      %Url{}
      |> Url.changeset(%{original_url: "https://valid.com", slug: "slug123"})
      |> Repo.insert!()

      changeset = Url.changeset(%Url{}, @valid_attrs)
      assert {:error, changeset} = Repo.insert(changeset)
      assert errors_on(changeset) == %{slug: ["Slug already exists"]}
    end
  end
end
