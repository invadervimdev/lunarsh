defmodule TestApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :test_app,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      preferred_cli_env: [
        "test.watch": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {TestApp.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    phoenix_version =
      "PHOENIX_VERSION"
      |> System.get_env("1.7.0")
      |> IO.inspect(label: "PHOENIX VERSION")

    phoenix_lv_version =
      "PHOENIX_LIVE_VIEW_VERSION"
      |> System.get_env("1.0.0")
      |> IO.inspect(label: "PHOENIX LIVE VIEW VERSION")

    [
      {:lunarsh, path: "../."},
      {:dom_helpers, "~> 0.3.1", only: [:test]},
      {:floki, ">= 0.36.0", override: true},
      {:jason, "~> 1.2"},
      {:live_isolated_component, "~> 0.9.0", only: [:dev, :test]},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:phoenix, "~> #{phoenix_version}"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.5", only: :dev},
      {:phoenix_live_view, "~> #{phoenix_lv_version}", override: true},
      {:plug_cowboy, "~> 2.5"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get"]
    ]
  end
end
