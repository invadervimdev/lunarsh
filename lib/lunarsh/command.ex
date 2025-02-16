defmodule Lunarsh.Command do
  @moduledoc """
  Commands can be thought of applications for this shell. The command must be
  defined, and then decides what is outputted when called.

  ## Example

  ```
  use Lunarsh.Command, name: "help", description: "Displays this message."
  ```

  ## Options

  - `name`: The text to call the command.
  - `description`: Describes what the command does. This will displayed when
    the user types `help`.

  """

  defmacro __using__(opts) do
    if !Keyword.has_key?(opts, :name),
      do: raise("Missing command name for #{inspect(__CALLER__.module)}")

    quote do
      use Phoenix.Component

      import Lunarsh.CoreComponents

      @behaviour Lunarsh.Command

      def __command__(:name), do: unquote(opts[:name])
      def __command__(:description), do: unquote(opts[:description])
    end
  end

  @callback help() :: String.t()
  @callback run(parameters :: list(), context :: map()) :: String.t()
  @optional_callbacks help: 0

  @doc """
  Lists every command that uses `Lunarsh.Command`.
  """
  @spec list :: list()
  def list do
    apps = [:lunarsh | Application.get_env(:lunarsh, :command_apps, [])]

    modules =
      apps
      |> Enum.map(fn app ->
        {:ok, mods} = :application.get_key(app, :modules)
        mods
      end)
      |> List.flatten()

    Enum.reduce(modules, %{}, fn mod, acc ->
      if Enum.member?(mod.__info__(:functions), {:__command__, 1}) do
        command = mod.__command__(:name)

        if Map.has_key?(acc, command) do
          raise "Command `#{command}` already exists!"
        else
          Map.put(acc, command, mod)
        end
      else
        acc
      end
    end)
  end
end
