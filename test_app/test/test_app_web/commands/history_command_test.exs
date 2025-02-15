defmodule TestAppWeb.Live.HistoryCommandTest do
  use TestAppWeb.Command

  describe "HistoryCommand" do
    test "displays the last 10 commands" do
      {:ok, view, _html} = load_shell()

      # does not include the most recent call to history
      html = enter_command(view, "history")
      refute html =~ "<li>history</li>"

      html = enter_command(view, "history")
      assert html =~ "<li>history</li>"

      enter_command(view, "one")
      enter_command(view, "two")
      enter_command(view, "three")
      enter_command(view, "four")
      enter_command(view, "five")
      enter_command(view, "six")
      enter_command(view, "seven")
      enter_command(view, "eight")
      enter_command(view, "nine")
      enter_command(view, "ten")
      html = enter_command(view, "history")

      assert html =~
               "<li>ten</li><li>nine</li><li>eight</li><li>seven</li><li>six</li><li>five</li><li>four</li><li>three</li><li>two</li><li>one</li></ol>"
    end

    test "displays the help message" do
      {:ok, view, _html} = load_shell()

      html =
        view
        |> element("form")
        |> render_submit(%{command_line: "help"})

      assert html =~ "<b>history</b> - Shows the last 10 commands entered."
    end
  end
end
