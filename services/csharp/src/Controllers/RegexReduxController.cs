using Microsoft.AspNetCore.Mvc;
using System.Text;
using System.Text.RegularExpressions;

namespace CSharpBenchmark.Controllers;

[ApiController]
[Route("api")]
public class RegexReduxController : ControllerBase
{
    [HttpGet("regex-redux")]
    public IActionResult GetRegexRedux()
    {
        // Define regex patterns (case-insensitive, global)
        var regExps = new[]
        {
            new Regex(@"agggtaaa|tttaccct", RegexOptions.IgnoreCase),
            new Regex(@"[cgt]gggtaaa|tttaccc[acg]", RegexOptions.IgnoreCase),
            new Regex(@"a[act]ggtaaa|tttacc[agt]t", RegexOptions.IgnoreCase),
            new Regex(@"ag[act]gtaaa|tttac[agt]ct", RegexOptions.IgnoreCase),
            new Regex(@"agg[act]taaa|ttta[agt]cct", RegexOptions.IgnoreCase),
            new Regex(@"aggg[acg]aaa|ttt[cgt]ccct", RegexOptions.IgnoreCase),
            new Regex(@"agggt[cgt]aa|tt[acg]accct", RegexOptions.IgnoreCase),
            new Regex(@"agggta[cgt]a|t[acg]taccct", RegexOptions.IgnoreCase),
            new Regex(@"agggtaa[cgt]|[acg]ttaccct", RegexOptions.IgnoreCase)
        };

        // Use a sample DNA sequence for testing
        var sampleData = @"
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
  ";

        var data = sampleData;
        var initialLen = data.Length;

        // Remove lines starting with '>' and all newlines
        data = Regex.Replace(data, @"^>.*\n|\n", "", RegexOptions.Multiline);
        var cleanedLen = data.Length;

        // Count matches for each pattern
        var results = new List<string>();
        foreach (var re in regExps)
        {
            var matches = re.Matches(data);
            results.Add($"{re.ToString()} {matches.Count}");
        }

        // Perform replacement chain
        var endLen = Regex.Replace(
            Regex.Replace(
                Regex.Replace(
                    Regex.Replace(
                        Regex.Replace(data, @"tHa[Nt]", "<4>"),
                        @"aND|caN|Ha[DS]|WaS", "<3>"),
                    @"a[NSt]|BY", "<2>"),
                @"<[^>]*>", "|"),
            @"\|[^|][^|]*\|", "-").Length;

        var response = new StringBuilder();
        response.AppendLine($"Initial length: {initialLen}");
        response.AppendLine($"Cleaned length: {cleanedLen}");
        response.AppendLine($"Final length: {endLen}");
        response.AppendLine();
        response.AppendLine("Pattern matches:");
        foreach (var result in results)
        {
            response.AppendLine(result);
        }

        return Ok(response.ToString());
    }
}

