defmodule ShorterWeb.ErrorHTMLTest do
  use ShorterWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template

  test "renders 404.html" do
    rendered_content = render_to_string(ShorterWeb.ErrorHTML, "404", "html", [])
    assert String.contains?(rendered_content, "Sorry, we couldn't find this page.")
  end
end
