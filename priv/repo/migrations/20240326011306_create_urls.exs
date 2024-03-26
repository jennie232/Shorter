defmodule Shorter.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :original_url, :text, null: false
      add :slug, :string, null: false
      add :clicks, :integer, default: 0
      timestamps()
    end

    create unique_index(:urls, [:slug])
  end
end
