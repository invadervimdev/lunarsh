defmodule TestAppWeb.Live.QuoteCommandTest do
  use TestAppWeb.ConnCase, async: true

  import LiveIsolatedComponent
  import Phoenix.LiveViewTest

  alias Lunarsh.ShellComponent

  describe "QuoteCommand" do
    test "displays a quote" do
      {:ok, view, _html} = live_isolated_component(ShellComponent)

      html =
        view
        |> element("form")
        |> render_submit(%{command_line: "quote"})

      assert html =~ "Size matters not."
    end

    test "displays the help message" do
      {:ok, view, _html} = live_isolated_component(ShellComponent)

      html =
        view
        |> element("form")
        |> render_submit(%{command_line: "help"})

      assert html =~ "<b>quote</b> - Displays a random quote."
    end
  end
end
