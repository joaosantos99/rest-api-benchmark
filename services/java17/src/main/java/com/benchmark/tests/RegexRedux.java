package com.benchmark.tests;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class RegexRedux implements HttpHandler {
    @Override
    public void handle(HttpExchange exchange) throws IOException {
        // Define regex patterns
        Pattern[] regExps = {
            Pattern.compile("agggtaaa|tttaccct", Pattern.CASE_INSENSITIVE),
            Pattern.compile("[cgt]gggtaaa|tttaccc[acg]", Pattern.CASE_INSENSITIVE),
            Pattern.compile("a[act]ggtaaa|tttacc[agt]t", Pattern.CASE_INSENSITIVE),
            Pattern.compile("ag[act]gtaaa|tttac[agt]ct", Pattern.CASE_INSENSITIVE),
            Pattern.compile("agg[act]taaa|ttta[agt]cct", Pattern.CASE_INSENSITIVE),
            Pattern.compile("aggg[acg]aaa|ttt[cgt]ccct", Pattern.CASE_INSENSITIVE),
            Pattern.compile("agggt[cgt]aa|tt[acg]accct", Pattern.CASE_INSENSITIVE),
            Pattern.compile("agggta[cgt]a|t[acg]taccct", Pattern.CASE_INSENSITIVE),
            Pattern.compile("agggtaa[cgt]|[acg]ttaccct", Pattern.CASE_INSENSITIVE)
        };

        // Use a sample DNA sequence for testing since we can't read from stdin in a web context
        String sampleData =
            ">ONE Homo sapiens aluGGCCGGGCGCGGTGGCTCACGCCTGTAA\n" +
            "AGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAAC\n" +
            "ATGGTGAAACCCCGTCTCTACTAAAAATACAAAAATTAGCCGGGCGTGG\n" +
            "TGGCGCATGCCTGTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAAT\n" +
            "CGCTTGAACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACT\n" +
            "GCACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAAGGCCGGG\n" +
            "CGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGG\n" +
            "CGGATCACCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACATGGTGA\n" +
            "AACCCCGTCTCTACTAAAAATACAAAAATTAGCCGGGCGTGGTGGCGCA\n" +
            "TGCCTGTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGA\n" +
            "ACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC\n" +
            "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAAGGCCGGGCGCGGTG\n" +
            "GCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGGCGGATCA\n" +
            "CCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACATGGTGAAACCCCG\n" +
            "TCTCTACTAAAAATACAAAAATTAGCCGGGCGTGGTGGCGCATGCCTGT\n" +
            "AATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG\n" +
            "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCCAGCCTGG\n" +
            "GCGACAGAGCGAGACTCCGTCTCAAAAA\n";

        String data = sampleData;
        int initialLen = data.length();

        // Remove header lines (lines starting with >) and newlines
        data = data.replaceAll("(?m)^>.*\n", "");
        data = data.replaceAll("\n", "");
        int cleanedLen = data.length();

        // Count matches for each regex pattern
        List<String> results = new ArrayList<>();
        for (Pattern re : regExps) {
            Matcher m = re.matcher(data);
            int count = 0;
            while (m.find()) {
                count++;
            }
            results.add(re.pattern() + " " + count);
        }

        // Perform replacements to calculate final length
        String endData = data
            .replaceAll("tHa[Nt]", "<4>")
            .replaceAll("aND|caN|Ha[DS]|WaS", "<3>")
            .replaceAll("a[NSt]|BY", "<2>")
            .replaceAll("<[^>]*>", "|")
            .replaceAll("\\|[^|][^|]*\\|", "-");
        int endLen = endData.length();

        // Build response
        StringBuilder response = new StringBuilder();
        response.append("Initial length: ").append(initialLen).append("\n");
        response.append("Cleaned length: ").append(cleanedLen).append("\n");
        response.append("Final length: ").append(endLen).append("\n");
        response.append("\n");
        response.append("Pattern matches:\n");
        for (String result : results) {
            response.append(result).append("\n");
        }

        String responseStr = response.toString();
        exchange.getResponseHeaders().set("Content-Type", "text/plain");
        exchange.sendResponseHeaders(200, responseStr.length());
        OutputStream os = exchange.getResponseBody();
        os.write(responseStr.getBytes());
        os.close();
    }
}

