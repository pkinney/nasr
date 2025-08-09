defmodule NASR.MixProject do
  use Mix.Project

  def project do
    [
      app: :nasr,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "NASR",
      description: "A library for parsing and analyzing FAA NASR and dTPP data files",
      package: package()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "pkinney/nasr"},
      files: ~w(lib priv mix.exs README.md LICENSE)
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :req, :briefly]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:unzip, "~> 0.12.0"},
      {:nimble_csv, "~> 1.2"},
      {:recase, "~> 0.5"},
      {:term_stream, "~> 0.1.0"},
      {:req, "~> 0.5.0"},
      {:briefly, "~> 0.5.1"},
      {:timex, "~> 3.7"},
      {:sweet_xml, "~> 0.7"},
      {:floki, "~> 0.38.0"},
      {:styler, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.30", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      validate: [
        "clean",
        "compile --warnings-as-error",
        "format --check-formatted",
        "credo",
        "dialyzer"
      ]
    ]
  end
end
