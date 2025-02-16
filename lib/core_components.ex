defmodule Lunarsh.CoreComponents do
  @moduledoc """
  Provides core UI components.
  """

  use Phoenix.Component

  @doc """
  Renders a command link.

  ## Examples

      <.cmd_link command="help" myself={@myself} />
  """
  attr(:command, :string, required: true)
  attr(:class, :string, default: nil)
  attr(:myself, :any, required: true)

  def cmd_link(assigns) do
    ~H"""
      <.link
        class={["hover:text-blue-500 underline inline-block", @class]}
        phx-click="enter"
        phx-value-command_line={@command}
        phx-target={@myself}
      >
        {@command}
      </.link>
    """
  end
end
