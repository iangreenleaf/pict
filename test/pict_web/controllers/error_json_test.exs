defmodule PictWeb.ErrorJSONTest do
  use PictWeb.ConnCase, async: true

  test "renders 404" do
    assert PictWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert PictWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
