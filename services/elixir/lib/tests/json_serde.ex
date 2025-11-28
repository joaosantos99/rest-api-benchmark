defmodule ElixirBenchmark.Tests.JsonSerde do
  @moduledoc false

  def handler do
    sample_data = %{
      users: [
        %{id: 1, name: "Alice", email: "alice@example.com", active: true},
        %{id: 2, name: "Bob", email: "bob@example.com", active: false},
        %{id: 3, name: "Charlie", email: "charlie@example.com", active: true}
      ],
      metadata: %{
        version: "1.0.0",
        timestamp: DateTime.utc_now() |> DateTime.to_iso8601(),
        settings: %{
          theme: "dark",
          notifications: true,
          language: "en"
        }
      },
      statistics: %{
        totalUsers: 3,
        activeUsers: 2,
        averageAge: 28.5,
        tags: ["javascript", "nodejs", "benchmark", "json", "serialization"]
      }
    }

    n = 100

    json_str = Jason.encode!(sample_data)
    parsed = Jason.decode!(json_str)
    original_hash = print_hash(parsed, "Original")

    results =
      Enum.reduce(1..n, [], fn _i, acc ->
        serialized = Jason.encode!(parsed)
        deserialized = Jason.decode!(serialized)
        [deserialized | acc]
      end)
      |> Enum.reverse()

    final_hash = print_hash(results, "x#{n} Cycles")

    [
      original_hash,
      final_hash,
      "Performed #{n} serialization/deserialization cycles",
      "Original data size: #{byte_size(json_str)} bytes",
      "Final array size: #{length(results)} objects"
    ]
    |> Enum.join("\n")
  end

  defp print_hash(data, label \\ "") do
    str = Jason.encode!(data)
    hash = :crypto.hash(:md5, str) |> Base.encode16(case: :lower)
    label_str = if label != "", do: label <> " ", else: ""
    "#{label_str}MD5 Hash: #{hash}"
  end
end

