defmodule TestAppWeb.Live.ShellComponentTest do
  use TestAppWeb.ConnCase, async: true

  import LiveIsolatedComponent
  import Phoenix.LiveViewTest

  alias Lunarsh.ShellComponent

  describe "ShellComponent" do
    test "initally displays welcome message, which disappears after the first command entered" do
      welcome_msg = "Welcome to lunarsh!"
      command_msg = "The following commands are available:"

      {:ok, view, html} = live_isolated_component(ShellComponent)
      assert html =~ welcome_msg
      refute html =~ command_msg

      html =
        view
        |> element("form")
        |> render_submit(%{command_line: "help"})

      refute html =~ welcome_msg
      assert html =~ command_msg
    end
  end
end
