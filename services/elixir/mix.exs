defmodule ElixirBenchmark.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_benchmark,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ElixirBenchmark.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.7"},
      {:plug, "~> 1.16"},
      {:jason, "~> 1.4"}
    ]
  end

  defp releases do
    [
      elixir_benchmark: [
        include_executables_for: [:unix],
        steps: [:assemble, &copy_extra_files/1]
      ]
    ]
  end

  defp copy_extra_files(release) do
    File.cp_r("lib", Path.join(release.path, "lib"))
    release
  end
end
