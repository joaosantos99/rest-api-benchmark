using Microsoft.AspNetCore.Mvc;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

namespace CSharpBenchmark.Controllers;

[ApiController]
[Route("api")]
public class JsonSerdeController : ControllerBase
{
    // Computes MD5 hash of JSON-serialized data
    private static string PrintHash(object data, string label = "")
    {
        var jsonStr = JsonSerializer.Serialize(data);
        var bytes = Encoding.UTF8.GetBytes(jsonStr);
        var hashBytes = MD5.HashData(bytes);
        var hash = Convert.ToHexString(hashBytes).ToLower();
        return $"{(!string.IsNullOrEmpty(label) ? label + " " : "")}MD5 Hash: {hash}";
    }

    [HttpGet("json-serde")]
    public IActionResult GetJsonSerde()
    {
        var sampleData = new
        {
            users = new[]
            {
                new { id = 1, name = "Alice", email = "alice@example.com", active = true },
                new { id = 2, name = "Bob", email = "bob@example.com", active = false },
                new { id = 3, name = "Charlie", email = "charlie@example.com", active = true }
            },
            metadata = new
            {
                version = "1.0.0",
                timestamp = DateTime.UtcNow.ToString("O"),
                settings = new
                {
                    theme = "dark",
                    notifications = true,
                    language = "en"
                }
            },
            statistics = new
            {
                totalUsers = 3,
                activeUsers = 2,
                averageAge = 28.5,
                tags = new[] { "javascript", "nodejs", "benchmark", "json", "serialization" }
            }
        };

        const int n = 100; // Number of serialization/deserialization cycles

        var jsonStr = JsonSerializer.Serialize(sampleData);
        var parsed = JsonSerializer.Deserialize<JsonElement>(jsonStr);
        var originalHash = PrintHash(parsed, "Original");

        var results = new List<JsonElement>();
        for (int i = 0; i < n; i++)
        {
            var serialized = JsonSerializer.Serialize(parsed);
            var deserialized = JsonSerializer.Deserialize<JsonElement>(serialized);
            results.Add(deserialized);
        }

        var finalHash = PrintHash(results, $"x{n} Cycles");

        var response = string.Join("\n", new[]
        {
            originalHash,
            finalHash,
            $"Performed {n} serialization/deserialization cycles",
            $"Original data size: {jsonStr.Length} bytes",
            $"Final array size: {results.Count} objects"
        });

        return Ok(response);
    }
}

