defmodule Keycloak.MixProject do
  use Mix.Project

  def project do
    [
      app: :keycloak_ex,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Keycloak.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:oauth2, "~> 2.0"},
      {:finch, "~> 0.8"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
end
