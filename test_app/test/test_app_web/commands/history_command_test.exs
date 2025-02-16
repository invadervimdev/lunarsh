defmodule TestAppWeb.Live.HistoryCommandTest do
  use TestAppWeb.Command

  describe "HistoryCommand" do
    test "displays the last 10 commands" do
      {:ok, view, _html} = load_shell()

      # does not include the most recent call to history
      html = enter_command(view, "history")
      refute String.match?(html, history_item_regex("history"))

      html = enter_command(view, "history")
      assert String.match?(html, history_item_regex("history"))

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

      assert [
               "ten",
               "nine",
               "eight",
               "seven",
               "six",
               "five",
               "four",
               "three",
               "two",
               "one",
               "history"
             ] =
               ~r/phx-value-command_line="(.*)"/
               |> Regex.scan(html)
               |> Enum.map(fn [_, cmd] -> cmd end)
    end

    test "displays the help message" do
      {:ok, view, _html} = load_shell()

      html =
        view
        |> element("form")
        |> render_submit(%{command_line: "help"})

      assert html =~ "history\n  </a> - Shows the last 10 commands entered.\n"
    end
  end

  defp history_item_regex(command) do
    ~r/phx-value-command_line="#{command}"/
  end
end
