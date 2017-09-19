defmodule TeslaTimeout.Mixfile do
  use Mix.Project

  @description """
  TeslaTimeout is a middleware for Elixir Tesla HTTP Client
  """

  @project_url "https://github.com/globocom/tesla_middleware"

  def project do
    [
      app: :tesla_timeout,
      version: "0.1.0",
      elixir: "~> 1.4",
      start_permanent: Mix.env == :prod,
      description: @description,
      source_url: @project_url,
      homepage_url: @project_url,
      package: package(),
      test_coverage: [tool: ExCoveralls],
      name: "TeslaTimeout",
      docs: [
        main: "TeslaTimeout",
        source_url: @project_url
      ],
      deps: deps()
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
      {:tesla, "~> 0.7.1", only: [:docs, :dev, :test]},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:mock, "~> 0.3.1", only: :test},
      {:excoveralls, "~> 0.7", only: :test},
      {:inch_ex, only: :docs}
    ]
  end

  defp package do
    [
      name: "Tesla Timeout Middleware",
      maintainers: ["Globo.com"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/globocom/tesla_timeout"}
    ]
  end
end
