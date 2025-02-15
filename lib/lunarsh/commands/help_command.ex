defmodule Lunarsh.Commands.HelpCommand do
  @moduledoc """
  Displays the list of available commands.

  Since this is not a traditional shell and custom commands can be created, it
  makes it easy on the users to tell them what commands they can run.
  """

  use Lunarsh.Command, name: "help", description: "Displays this message."

  @impl true
  def run(_parameters, _ctx) do
    show(%{commands: Lunarsh.Command.list()})
  end

  defp show(assigns) do
    ~H"""
    The following commands are available:
    <ul class="list-none list-outside">
      <%= for {name, command_mod} <- @commands do %>
        <li class="my-1 ml-4">
          <b>{name}</b> - {command_mod.__command__(:description)}
        </li>
      <% end %>
    </ul>
    """
  end
end
