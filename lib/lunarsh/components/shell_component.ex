defmodule Lunarsh.ShellComponent do
  @moduledoc """
  Renders a shell.

  ## Usage

  ```
  <.live_component
    module={Lunarsh.ShellComponent}
    id="my-shell"
    welcome_message={welcome_message()}
    }
  />
  ```

  ## Options

  - `welcome_message`: Accepts a `Phoenix.LiveView.Rendered` structure. If blank, will use
    `default_welcome_message/1`.
  """

  use Phoenix.LiveComponent

  alias Phoenix.LiveView.JS

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign_form()
     |> assign(:history, [])
     |> assign(:output, [])}
  end

  @impl true
  def update(%{command_line: command_line}, socket) do
    {:ok, enter_command_line(socket, command_line)}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="h-full flex flex-col font-mono text-sm text-white">
      <div class="grow overflow-y-auto">
        <%= if Enum.any?(@history) do %>
          <div class="h-full flex flex-col-reverse px-4 overflow-y-auto ">
            <%= for result <- @output do %>
              {result}
            <% end %>
          </div>
        <% else %>
          {assigns[:welcome_message] || default_welcome_message()}
        <% end %>
      </div>
      <div class="shrink-0 px-4 mb-4">
        <.form for={@form} phx-change="change" phx-submit="enter" phx-target={@myself}>
          <div class="flex bg-transparent">
            <div class="shrink-0 text-base text-gray-500 select-none">
              {prompt()}&nbsp;
            </div>
            <input
              type="text"
              name={@form[:command_line].name}
              id={@form[:command_line].id}
              class={[
                "grow bg-transparent border-none focus:ring-0 text-sm m-0 p-0 leading-[0] w-full"
              ]}
              phx-mounted={JS.focus()}
              phx-window-focus={JS.focus()}
              phx-click-away={JS.focus()}
            />
          </div>
        </.form>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("change", %{"command_line" => command_line}, socket) do
    # Need this to track form changes, which allows us to reset the input after
    # a command has been entered.
    {:noreply, assign_form(socket, command_line)}
  end

  @impl true
  def handle_event("enter", %{"command_line" => command_line}, socket) do
    {:noreply, enter_command_line(socket, command_line)}
  end

  def prompt(assigns \\ %{}) do
    ~H"""
    <span class="text-blue-500">$</span>
    """
  end

  defp assign_form(socket, command \\ "") do
    assign(socket, form: to_form(%{"command_line" => command}))
  end

  defp default_welcome_message(assigns \\ %{}) do
    ~H"""
    <div class="flex min-h-full justify-center items-center text-center text-lg">
      Welcome to lunarsh!<br />
      Type `help` to get started.
    </div>
    """
  end

  defp enter_command_line(socket, command_line) do
    socket
    |> save_command_line(command_line)
    |> process_command_line()
    |> assign_form()
  end

  defp process_command_line(socket) do
    [command_line | _rest] = socket.assigns.history
    [command | parameters] = String.split(command_line, " ")
    run_command(command, parameters, socket)
  end

  defp render_result(assigns) do
    ~H"""
    <div class="shrink-0 mb-1">{@result}</div>
    <div class="shrink-0 my-1">{prompt(assigns)} {@command_line}</div>
    """
  end

  defp run_command("clear", _, socket), do: assign(socket, output: [])

  defp run_command(command, parameters, socket) do
    result =
      case Map.get(Lunarsh.Command.list(), command) do
        nil ->
          unknown_command(command)

        mod ->
          mod.run(parameters, history: socket.assigns.history)
      end

    rendered =
      render_result(%{command_line: Enum.join([command | parameters], " "), result: result})

    assign(socket, output: [rendered | socket.assigns.output])
  end

  defp save_command_line(socket, command_line) do
    assign(socket, history: [command_line | socket.assigns.history])
  end

  defp unknown_command(command), do: "command not found: #{command}"
end
