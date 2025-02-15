defmodule Lunarsh.Commands.ClearCommand do
  @moduledoc """
  Clears the output.

  This is all handled internally in `ShellComponent`, but is added here to let
  the user know the command exists.
  """

  use Lunarsh.Command, name: "clear", description: "Clears the screen of all output."

  @impl true
  def run(_parameters, _ctx), do: ""
end
