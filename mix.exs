defmodule MixTestObserver.MixProject do
  use Mix.Project

  def project do
    [
      app: :mix_test_observer,
      version: "0.1.0",
      elixir: "~> 1.13",
      escript: [main_module: MixTestObserver.Cli],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [plt_add_apps: [:mix]],

      # Docs
      name: "MixTestObserver",
      source_url: "https://github.com/Ta-To/mix_test_observer",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.28", only: [:dev], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:file_system, "~> 0.2"}
    ]
  end

  defp docs do
    [
      main: "readme",
      api_reference: false,
      extras: ["README.md"]
    ]
  end
end
