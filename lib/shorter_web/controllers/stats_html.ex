defmodule ShorterWeb.StatsHTML do
  use ShorterWeb, :html
  alias ShorterWeb.Router.Helpers, as: Routes
  embed_templates "stats_html/*"
end
