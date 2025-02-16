defmodule TestAppWeb.Live.HelpCommandTest do
  use TestAppWeb.ConnCase, async: true

  import LiveIsolatedComponent
  import Phoenix.LiveViewTest

  alias Lunarsh.ShellComponent

  describe "HelpCommand" do
    test "displays the list of commands" do
      {:ok, view, _html} = live_isolated_component(ShellComponent)

      html =
        view
        |> element("form")
        |> render_submit(%{command_line: "help"})

      assert html =~ "The following commands are available:"
      assert html =~ "help\n  </a> - Displays this message.\n"
    end
  end
end
