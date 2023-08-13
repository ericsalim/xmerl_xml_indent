defmodule XmerlXmlIndent.MixProject do
  use Mix.Project

  def project do
    [
      app: :xmerl_xml_indent,
      version: "0.1.0",
      elixir: "~> 1.12",
      name: "XmerlXmlIndent",
      description: description(),
      package: package(),
      source_url: github_url(),
      deps: deps(),
      docs: [
        extras: ["README.md"],
        main: "readme"
      ]
    ]
  end

  defp package do
    [
      name: "xmerl_xml_indent",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      licenses: ["Apache-2.0"],
      maintainers: ["Eric Salim"],
      links: %{"GitHub" => github_url()}
    ]
  end

  def application do
    [
      extra_applications: [:xmerl]
    ]
  end

  defp description() do
    "A callback module to write XML with indentation for Elixir"
  end

  defp github_url() do
    "https://github.com/ericsalim/xmerl_xml_indent"
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false}
    ]
  end
end
