defmodule ElixirBenchmark.Router do
  @moduledoc false

  use Plug.Router

  plug Plug.Logger
  plug :match
  plug Plug.Parsers, parsers: [:urlencoded, :multipart, :json], json_decoder: Jason
  plug :dispatch

  get "/api/hello-world" do
    response = ElixirBenchmark.Tests.HelloWorld.handler()
    send_resp(conn, 200, response)
  end

  get "/api/n-body" do
    response = ElixirBenchmark.Tests.NBody.handler()
    send_resp(conn, 200, response)
  end

  get "/api/json-serde" do
    response = ElixirBenchmark.Tests.JsonSerde.handler()
    send_resp(conn, 200, response)
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
