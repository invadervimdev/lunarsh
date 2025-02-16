defmodule TestAppWeb.Live.ClearCommandTest do
  use TestAppWeb.ConnCase, async: true

  import LiveIsolatedComponent
  import Phoenix.LiveViewTest

  alias Lunarsh.ShellComponent

  describe "ClearCommand" do
    test "clears the output" do
      help_msg = "The following commands are available:"
      {:ok, view, _html} = live_isolated_component(ShellComponent)

      html =
        view
        |> element("form")
        |> render_submit(%{command_line: "help"})

      assert html =~ help_msg

      html =
        view
        |> element("form")
        |> render_submit(%{command_line: "clear"})

      refute html =~ help_msg
    end

    test "displays the help message" do
      {:ok, view, _html} = live_isolated_component(ShellComponent)

      html =
        view
        |> element("form")
        |> render_submit(%{command_line: "help"})

      assert html =~ "clear\n  </a> - Clears the screen of all output.\n"
    end
  end
end
