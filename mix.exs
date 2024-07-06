defmodule MixTestObserver.MixProject do
  use Mix.Project

  @version "0.1.2"
  @source_url "https://github.com/tato-gh/mix_test_observer"

  def project do
    [
      app: :mix_test_observer,
      version: @version,
      elixir: "~> 1.13",
      escript: [main_module: MixTestObserver.Cli],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # Docs
      name: "MixTestObserver",
      description: "MixTestObserver is a semiauto test runner.",
      source_url: @source_url,
      docs: docs(),
      package: package(),
      dialyzer: [plt_add_apps: [:mix]]
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
      {:file_system, "~> 1.0"}
    ]
  end

  defp docs do
    [
      main: "readme",
      api_reference: false,
      extras: ["README.md"]
    ]
  end

  defp package do
    [
      maintainers: ["ta.to."],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
