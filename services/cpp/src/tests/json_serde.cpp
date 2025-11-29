#include "json_serde.h"
#include <nlohmann/json.hpp>
#include <openssl/md5.h>
#include <sstream>
#include <iomanip>
#include <vector>
#include <ctime>
#include <chrono>

using json = nlohmann::json;

// Helper function to compute MD5 hash
std::string printHash(const json& data, const std::string& label = "") {
    std::string jsonStr = data.dump();

    unsigned char hash[MD5_DIGEST_LENGTH];
    MD5(reinterpret_cast<const unsigned char*>(jsonStr.c_str()), jsonStr.length(), hash);

    std::ostringstream oss;
    if (!label.empty()) {
        oss << label << " ";
    }
    oss << "MD5 Hash: ";
    for (int i = 0; i < MD5_DIGEST_LENGTH; i++) {
        oss << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(hash[i]);
    }

    return oss.str();
}

crow::response json_serde() {
    // Get current timestamp in ISO 8601 format
    auto now = std::chrono::system_clock::now();
    auto time_t = std::chrono::system_clock::to_time_t(now);
    std::tm tm_buf;
    #ifdef _WIN32
        gmtime_s(&tm_buf, &time_t);
    #else
        gmtime_r(&time_t, &tm_buf);
    #endif
    char timestamp[32];
    std::strftime(timestamp, sizeof(timestamp), "%Y-%m-%dT%H:%M:%S.000Z", &tm_buf);

    // Create sample data
    json sampleData = {
        {"users", {
            {{"id", 1}, {"name", "Alice"}, {"email", "alice@example.com"}, {"active", true}},
            {{"id", 2}, {"name", "Bob"}, {"email", "bob@example.com"}, {"active", false}},
            {{"id", 3}, {"name", "Charlie"}, {"email", "charlie@example.com"}, {"active", true}}
        }},
        {"metadata", {
            {"version", "1.0.0"},
            {"timestamp", timestamp},
            {"settings", {
                {"theme", "dark"},
                {"notifications", true},
                {"language", "en"}
            }}
        }},
        {"statistics", {
            {"totalUsers", 3},
            {"activeUsers", 2},
            {"averageAge", 28.5},
            {"tags", {"javascript", "nodejs", "benchmark", "json", "serialization"}}
        }}
    };

    const int n = 100; // Number of serialization/deserialization cycles

    std::string jsonStr = sampleData.dump();
    json parsed = json::parse(jsonStr);
    std::string originalHash = printHash(parsed, "Original");

    std::vector<json> results;
    results.reserve(n);
    for (int i = 0; i < n; i++) {
        std::string serialized = parsed.dump();
        json deserialized = json::parse(serialized);
        results.push_back(deserialized);
    }

    json resultsArray = results;
    std::string finalHash = printHash(resultsArray, "x" + std::to_string(n) + " Cycles");

    std::ostringstream response;
    response << originalHash << "\n"
             << finalHash << "\n"
             << "Performed " << n << " serialization/deserialization cycles\n"
             << "Original data size: " << jsonStr.length() << " bytes\n"
             << "Final array size: " << results.size() << " objects\n";

    return crow::response(200, response.str());
}

