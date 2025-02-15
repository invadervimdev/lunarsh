defmodule TestAppWeb.Commands.QuoteCommand do
  @moduledoc """
  A command in the test app that should be picked up by the library.
  """

  use Lunarsh.Command, name: "quote", description: "Displays a random quote."

  @impl true
  def run(_parameters, _ctx), do: "Size matters not."
end
