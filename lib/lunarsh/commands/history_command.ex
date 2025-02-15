defmodule Lunarsh.Commands.HistoryCommand do
  @moduledoc """
  Shows a list of inputted commands.
  """

  use Lunarsh.Command, name: "history", description: "Shows the last 10 commands entered."

  @impl true
  def run(_parameters, ctx) do
    # Don't show the latest call to `history`
    [_first_command | history] = Keyword.get(ctx, :history)
    show(%{history: Enum.take(history, 10)})
  end

  defp show(assigns) do
    ~H"""
    <ol class="list-none list-inside flex flex-col-reverse">
      <%= for command_line <- @history do %>
        <li>{command_line}</li>
      <% end %>
    </ol>
    """
  end
end
