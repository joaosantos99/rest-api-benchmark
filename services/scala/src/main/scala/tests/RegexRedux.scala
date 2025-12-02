package tests

import scala.util.matching.Regex

object RegexRedux {
  // Define regex patterns (case-insensitive)
  private val regExps = List(
    """(?i)agggtaaa|tttaccct""".r.unanchored,
    """(?i)[cgt]gggtaaa|tttaccc[acg]""".r.unanchored,
    """(?i)a[act]ggtaaa|tttacc[agt]t""".r.unanchored,
    """(?i)ag[act]gtaaa|tttac[agt]ct""".r.unanchored,
    """(?i)agg[act]taaa|ttta[agt]cct""".r.unanchored,
    """(?i)aggg[acg]aaa|ttt[cgt]ccct""".r.unanchored,
    """(?i)agggt[cgt]aa|tt[acg]accct""".r.unanchored,
    """(?i)agggta[cgt]a|t[acg]taccct""".r.unanchored,
    """(?i)agggtaa[cgt]|[acg]ttaccct""".r.unanchored
  )

  private val patternStrings = List(
    "agggtaaa|tttaccct",
    "[cgt]gggtaaa|tttaccc[acg]",
    "a[act]ggtaaa|tttacc[agt]t",
    "ag[act]gtaaa|tttac[agt]ct",
    "agg[act]taaa|ttta[agt]cct",
    "aggg[acg]aaa|ttt[cgt]ccct",
    "agggt[cgt]aa|tt[acg]accct",
    "agggta[cgt]a|t[acg]taccct",
    "agggtaa[cgt]|[acg]ttaccct"
  )

  def regexRedux(): String = {
    // Use a sample DNA sequence for testing since we can't read from stdin in a web context
    val sampleData =
      """
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
  """

    var data = sampleData
    val initialLen = data.length

    // Remove lines starting with > and all newlines
    data = """(?m)^>.*\n|\n""".r.replaceAllIn(data, "")
    val cleanedLen = data.length

    // Count matches for each pattern (case-insensitive)
    val results = regExps.zip(patternStrings).map { case (re, patternStr) =>
      val matches = re.findAllIn(data).toList.length
      s"$patternStr $matches"
    }

    // Apply replacement chain
    val endLen = data
      .replaceAll("(?i)tHa[Nt]", "<4>")
      .replaceAll("(?i)aND|caN|Ha[DS]|WaS", "<3>")
      .replaceAll("(?i)a[NSt]|BY", "<2>")
      .replaceAll("<[^>]*>", "|")
      .replaceAll("\\|[^|][^|]*\\|", "-")
      .length

    val response = List(
      s"Initial length: $initialLen",
      s"Cleaned length: $cleanedLen",
      s"Final length: $endLen",
      "",
      "Pattern matches:"
    ) ++ results

    response.mkString("\n")
  }
}

