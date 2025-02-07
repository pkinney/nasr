defmodule NASR.MixProject do
  use Mix.Project

  def project do
    [
      app: :nasr,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {NASR.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:unzip, "~> 0.12.0"},
      {:nimble_csv, "~> 1.2"},
      {:recase, "~> 0.5"},
      {:term_stream, "~> 0.1.0"},
      {:styler, "~> 1.0.0-rc.1", only: [:dev, :test], runtime: false}
    ]
  end
end
