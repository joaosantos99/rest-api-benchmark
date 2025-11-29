package tests

import io.circe.*
import io.circe.syntax.*
import java.security.MessageDigest
import java.time.Instant

object JsonSerde {
  private val N = 100 // Number of serialization/deserialization cycles

  // Helper method to compute MD5 hash
  private def printHash(data: Json, label: String = ""): String = {
    try {
      val jsonStr = data.noSpaces
      val md = MessageDigest.getInstance("MD5")
      val hashBytes = md.digest(jsonStr.getBytes("UTF-8"))
      val hashHex = hashBytes.map(b => f"${b & 0xff}%02x").mkString
      val labelStr = if (label.nonEmpty) s"$label " else ""
      s"${labelStr}MD5 Hash: $hashHex"
    } catch {
      case e: Exception => s"Error computing hash: ${e.getMessage}"
    }
  }

  def jsonSerde(): String = {
    // Create sample data structure
    val sampleData = Json.obj(
      "users" -> Json.arr(
        Json.obj(
          "id" -> 1.asJson,
          "name" -> "Alice".asJson,
          "email" -> "alice@example.com".asJson,
          "active" -> true.asJson
        ),
        Json.obj(
          "id" -> 2.asJson,
          "name" -> "Bob".asJson,
          "email" -> "bob@example.com".asJson,
          "active" -> false.asJson
        ),
        Json.obj(
          "id" -> 3.asJson,
          "name" -> "Charlie".asJson,
          "email" -> "charlie@example.com".asJson,
          "active" -> true.asJson
        )
      ),
      "metadata" -> Json.obj(
        "version" -> "1.0.0".asJson,
        "timestamp" -> Instant.now().toString.asJson,
        "settings" -> Json.obj(
          "theme" -> "dark".asJson,
          "notifications" -> true.asJson,
          "language" -> "en".asJson
        )
      ),
      "statistics" -> Json.obj(
        "totalUsers" -> 3.asJson,
        "activeUsers" -> 2.asJson,
        "averageAge" -> 28.5.asJson,
        "tags" -> Json.arr(
          "javascript".asJson,
          "nodejs".asJson,
          "benchmark".asJson,
          "json".asJson,
          "serialization".asJson
        )
      )
    )

    val jsonStr = sampleData.noSpaces
    val parsed = parser.parse(jsonStr).getOrElse(Json.Null)
    val originalHash = printHash(parsed, "Original")

    val results = (0 until N).map { _ =>
      val serialized = parsed.noSpaces
      parser.parse(serialized).getOrElse(Json.Null)
    }

    val resultsArray = Json.arr(results*)
    val finalHash = printHash(resultsArray, s"x$N Cycles")

    val response = List(
      originalHash,
      finalHash,
      s"Performed $N serialization/deserialization cycles",
      s"Original data size: ${jsonStr.length} bytes",
      s"Final array size: ${results.size} objects"
    ).mkString("\n")

    response
  }
}

