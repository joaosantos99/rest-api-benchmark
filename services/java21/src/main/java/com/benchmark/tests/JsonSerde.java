package com.benchmark.tests;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import java.io.IOException;
import java.io.OutputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

public class JsonSerde implements HttpHandler {
    private static final Gson gson = new Gson();
    private static final int N = 100; // Number of serialization/deserialization cycles

    // Helper method to compute MD5 hash
    private String printHash(Object data, String label) {
        try {
            String jsonStr = gson.toJson(data);
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hashBytes = md.digest(jsonStr.getBytes("UTF-8"));
            StringBuilder hashHex = new StringBuilder();
            for (byte b : hashBytes) {
                hashHex.append(String.format("%02x", b));
            }
            String labelStr = label.isEmpty() ? "" : label + " ";
            return labelStr + "MD5 Hash: " + hashHex.toString();
        } catch (Exception e) {
            return "Error computing hash: " + e.getMessage();
        }
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        // Create sample data structure
        JsonObject sampleData = new JsonObject();

        // Users array
        JsonArray users = new JsonArray();
        JsonObject user1 = new JsonObject();
        user1.addProperty("id", 1);
        user1.addProperty("name", "Alice");
        user1.addProperty("email", "alice@example.com");
        user1.addProperty("active", true);
        users.add(user1);

        JsonObject user2 = new JsonObject();
        user2.addProperty("id", 2);
        user2.addProperty("name", "Bob");
        user2.addProperty("email", "bob@example.com");
        user2.addProperty("active", false);
        users.add(user2);

        JsonObject user3 = new JsonObject();
        user3.addProperty("id", 3);
        user3.addProperty("name", "Charlie");
        user3.addProperty("email", "charlie@example.com");
        user3.addProperty("active", true);
        users.add(user3);

        sampleData.add("users", users);

        // Metadata object
        JsonObject metadata = new JsonObject();
        metadata.addProperty("version", "1.0.0");
        metadata.addProperty("timestamp", Instant.now().toString());

        JsonObject settings = new JsonObject();
        settings.addProperty("theme", "dark");
        settings.addProperty("notifications", true);
        settings.addProperty("language", "en");
        metadata.add("settings", settings);

        sampleData.add("metadata", metadata);

        // Statistics object
        JsonObject statistics = new JsonObject();
        statistics.addProperty("totalUsers", 3);
        statistics.addProperty("activeUsers", 2);
        statistics.addProperty("averageAge", 28.5);

        JsonArray tags = new JsonArray();
        tags.add("javascript");
        tags.add("nodejs");
        tags.add("benchmark");
        tags.add("json");
        tags.add("serialization");
        statistics.add("tags", tags);

        sampleData.add("statistics", statistics);

        String jsonStr = gson.toJson(sampleData);
        JsonObject parsed = gson.fromJson(jsonStr, JsonObject.class);
        String originalHash = printHash(parsed, "Original");

        List<JsonObject> results = new ArrayList<>();
        for (int i = 0; i < N; i++) {
            String serialized = gson.toJson(parsed);
            JsonObject deserialized = gson.fromJson(serialized, JsonObject.class);
            results.add(deserialized);
        }

        String finalHash = printHash(results, "x" + N + " Cycles");

        String response = String.join("\n",
            originalHash,
            finalHash,
            "Performed " + N + " serialization/deserialization cycles",
            "Original data size: " + jsonStr.length() + " bytes",
            "Final array size: " + results.size() + " objects"
        );

        exchange.getResponseHeaders().set("Content-Type", "text/plain");
        exchange.sendResponseHeaders(200, response.length());
        OutputStream os = exchange.getResponseBody();
        os.write(response.getBytes());
        os.close();
    }
}

