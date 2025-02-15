defmodule TestAppWeb.Command do
  @moduledoc """
  Helpful functions to make testing easier.
  """

  defmacro __using__(_opts) do
    quote do
      use TestAppWeb.ConnCase, async: true
      import Phoenix.LiveViewTest

      defdelegate enter_command(view, command_line), to: TestAppWeb.Command
      defdelegate load_shell, to: TestAppWeb.Command
    end
  end

  use TestAppWeb.ConnCase, async: true

  import LiveIsolatedComponent
  import Phoenix.LiveViewTest

  @doc """
  Submits the form with the provided command line.
  """
  def enter_command(view, command_line) do
    view
    |> element("form")
    |> render_submit(%{command_line: command_line})
  end

  @doc """
  Starts a shell live.
  """
  def load_shell, do: live_isolated_component(Lunarsh.ShellComponent)
end
