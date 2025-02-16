defmodule Lunarsh.Commands.HelpCommand do
  @moduledoc """
  Displays the list of available commands.

  Since this is not a traditional shell and custom commands can be created, it
  makes it easy on the users to tell them what commands they can run.
  """

  use Lunarsh.Command, name: "help", description: "Displays this message."

  @impl true
  def run(_parameters, ctx) do
    show(%{commands: Lunarsh.Command.list(), myself: ctx.myself})
  end

  defp show(assigns) do
    ~H"""
    The following commands are available:
    <ul class="list-none list-outside">
      <%= for {name, command_mod} <- @commands do %>
        <li class="my-1 ml-4">
          <.cmd_link command={name} myself={@myself} class="font-bold" /> - {command_mod.__command__(:description)}
        </li>
      <% end %>
    </ul>
    """
  end
end
