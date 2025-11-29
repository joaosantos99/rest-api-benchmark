#include "regex_redux.h"
#include <regex>
#include <string>
#include <sstream>
#include <vector>

crow::response regex_redux() {
    // Define regex patterns (case-insensitive)
    std::vector<std::regex> regExps = {
        std::regex("agggtaaa|tttaccct", std::regex_constants::icase),
        std::regex("[cgt]gggtaaa|tttaccc[acg]", std::regex_constants::icase),
        std::regex("a[act]ggtaaa|tttacc[agt]t", std::regex_constants::icase),
        std::regex("ag[act]gtaaa|tttac[agt]ct", std::regex_constants::icase),
        std::regex("agg[act]taaa|ttta[agt]cct", std::regex_constants::icase),
        std::regex("aggg[acg]aaa|ttt[cgt]ccct", std::regex_constants::icase),
        std::regex("agggt[cgt]aa|tt[acg]accct", std::regex_constants::icase),
        std::regex("agggta[cgt]a|t[acg]taccct", std::regex_constants::icase),
        std::regex("agggtaa[cgt]|[acg]ttaccct", std::regex_constants::icase)
    };

    std::vector<std::string> patternStrings = {
        "agggtaaa|tttaccct",
        "[cgt]gggtaaa|tttaccc[acg]",
        "a[act]ggtaaa|tttacc[agt]t",
        "ag[act]gtaaa|tttac[agt]ct",
        "agg[act]taaa|ttta[agt]cct",
        "aggg[acg]aaa|ttt[cgt]ccct",
        "agggt[cgt]aa|tt[acg]accct",
        "agggta[cgt]a|t[acg]taccct",
        "agggtaa[cgt]|[acg]ttaccct"
    };

    // Use a sample DNA sequence for testing since we can't read from stdin in a web context
    std::string sampleData = R"(
    >ONE Homo sapiens aluGGCCGGGCGCGGTGGCTCACGCCTGTAA
    AGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAAC
    ATGGTGAAACCCCGTCTCTACTAAAAATACAAAAATTAGCCGGGCGTGG
    TGGCGCATGCCTGTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAAT
    CGCTTGAACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACT
    GCACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAAGGCCGGG
    CGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGG
    CGGATCACCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACATGGTGA
    AACCCCGTCTCTACTAAAAATACAAAAATTAGCCGGGCGTGGTGGCGCA
    TGCCTGTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGA
    ACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC
    AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAAGGCCGGGCGCGGTG
    GCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGGCGGATCA
    CCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACATGGTGAAACCCCG
    TCTCTACTAAAAATACAAAAATTAGCCGGGCGTGGTGGCGCATGCCTGT
    AATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG
    AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCCAGCCTGG
    GCGACAGAGCGAGACTCCGTCTCAAAAA
  )";

    std::string data = sampleData;
    size_t initialLen = data.length();

    // Remove lines starting with > and all newlines
    // First remove lines starting with >
    std::regex cleanRe1(R"(>.*\n)");
    data = std::regex_replace(data, cleanRe1, "");
    // Then remove all remaining newlines
    std::regex cleanRe2(R"(\n)");
    data = std::regex_replace(data, cleanRe2, "");
    size_t cleanedLen = data.length();

    // Count matches for each pattern
    std::vector<std::string> results;
    for (size_t i = 0; i < regExps.size(); i++) {
        std::sregex_iterator iter(data.begin(), data.end(), regExps[i]);
        std::sregex_iterator end;
        size_t count = 0;
        for (; iter != end; ++iter) {
            count++;
        }
        results.push_back(patternStrings[i] + " " + std::to_string(count));
    }

    // Perform replacements
    data = std::regex_replace(data, std::regex("tHa[Nt]"), "<4>");
    data = std::regex_replace(data, std::regex("aND|caN|Ha[DS]|WaS"), "<3>");
    data = std::regex_replace(data, std::regex("a[NSt]|BY"), "<2>");
    data = std::regex_replace(data, std::regex("<[^>]*>"), "|");
    data = std::regex_replace(data, std::regex("\\|[^|][^|]*\\|"), "-");
    size_t endLen = data.length();

    // Build response
    std::ostringstream response;
    response << "Initial length: " << initialLen << "\n"
             << "Cleaned length: " << cleanedLen << "\n"
             << "Final length: " << endLen << "\n\n"
             << "Pattern matches:\n";

    for (const auto& result : results) {
        response << result << "\n";
    }

    return crow::response(200, response.str());
}

