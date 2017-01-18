defmodule Moneywave.Mixfile do
  use Mix.Project

  def project do
    [app: :moneywave,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def description do
    "Moneywave Api Client for Elixir"
  end

  def package do
    [
      name: "moneywave_elixir",
      maintainers: ["Aregbede Ayomide"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/ponty96/moneywave-elixir"}
    ]
  end
  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison],
     mod: {Moneywave, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:httpoison, "~> 0.11"},
     {:poison, "~> 2.2"}]
  end
end
