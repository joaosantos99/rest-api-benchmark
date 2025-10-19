defmodule ElixirBenchmark.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    port = System.get_env("PORT", "8080") |> String.to_integer()

    children = [
      {Plug.Cowboy, scheme: :http, plug: ElixirBenchmark.Router, options: [port: port]}
    ]

    opts = [strategy: :one_for_one, name: ElixirBenchmark.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
