defmodule Apresse.MixProject do
  use Mix.Project

  def project do
    [
      app: :apresse_web,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "Web server for displaying APRS-IS positions in a map",
      name: "Apresse"
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      maintainers: ["Kenji Rikitake"],
      links: %{"GitHub" => "https://github.com/jj1bdx/apresse"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {ApresseWeb, []},
      extra_applications: [:plug, :cowboy, :logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.5.1"},
      {:cowboy, "~> 1.0"}, 
      {:ex_doc, "~> 0.18", only: :dev}, 
      {:dialyxir, "~> 0.5.1", only: [:dev], runtime: false},
      {:exrm, "~> 1.0"}
    ]
  end
end
