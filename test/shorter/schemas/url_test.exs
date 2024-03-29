defmodule Shorter.Schemas.UrlTest do
  use ExUnit.Case
  use Shorter.DataCase
  import Ecto.Changeset
  alias Shorter.Schemas.Url

  describe "URL validations" do
    @valid_attrs %{original_url: "https://validurl.com"}

    test "with valid attributes" do
      changeset = Url.changeset(%Url{}, @valid_attrs)
      assert changeset.valid?
    end

    test "is invalid if scheme is other than http/https" do
      changeset = Url.changeset(%Url{}, %{original_url: "pps://invalidurl.com"})
      refute changeset.valid?
      assert errors_on(changeset) == %{original_url: ["URL scheme must be 'http' or 'https'"]}
    end

    test "is invalid if URL does not have host" do
      changeset = Url.changeset(%Url{}, %{original_url: "https://"})
      refute changeset.valid?
      assert errors_on(changeset) == %{original_url: ["URL does not have host"]}
    end

    test "is invalid if no original URL as input" do
      changeset = Url.changeset(%Url{}, %{})
      refute changeset.valid?
      assert errors_on(changeset) == %{original_url: ["can't be blank"]}
    end
  end
end
