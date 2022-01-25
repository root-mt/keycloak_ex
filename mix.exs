defmodule Keycloak.MixProject do
  use Mix.Project

  def project do
    [
      app: :keycloak_ex,
      version: "0.0.1",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "keycloak_ex",
      source_url: "https://github.com/root-mt/keycloak_ex"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
     # mod: {Keycloak.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:oauth2, "~> 2.0"},
      {:finch, "~> 0.8"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "A Keycloak integration"
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "keycloak_ex",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/root-mt/keycloak_ex"}
    ]
  end
end
