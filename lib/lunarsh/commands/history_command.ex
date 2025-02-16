defmodule Lunarsh.Commands.HistoryCommand do
  @moduledoc """
  Shows a list of inputted commands.
  """

  use Lunarsh.Command, name: "history", description: "Shows the last 10 commands entered."

  @impl true
  def run(_parameters, ctx) do
    # Don't show the latest call to `history`
    [_first_command | history] = ctx.history
    show(%{history: Enum.take(history, 10), myself: ctx.myself})
  end

  defp show(assigns) do
    ~H"""
    <ol class="list-none list-inside flex flex-col-reverse">
      <%= for command_line <- @history do %>
        <li><.cmd_link command={command_line} myself={@myself} class="no-underline" /></li>
      <% end %>
    </ol>
    """
  end
end
