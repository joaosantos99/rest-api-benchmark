defmodule ElixirBenchmark.Tests.RegexRedux do
  @moduledoc false

  def handler do
    reg_exps = [
      ~r/agggtaaa|tttaccct/i,
      ~r/[cgt]gggtaaa|tttaccc[acg]/i,
      ~r/a[act]ggtaaa|tttacc[agt]t/i,
      ~r/ag[act]gtaaa|tttac[agt]ct/i,
      ~r/agg[act]taaa|ttta[agt]cct/i,
      ~r/aggg[acg]aaa|ttt[cgt]ccct/i,
      ~r/agggt[cgt]aa|tt[acg]accct/i,
      ~r/agggta[cgt]a|t[acg]taccct/i,
      ~r/agggtaa[cgt]|[acg]ttaccct/i
    ]

    sample_data = """
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

    initial_len = String.length(sample_data)

    data =
      sample_data
      |> String.replace(~r/^>.*\n|\n/m, "")

    cleaned_len = String.length(data)

    results =
      Enum.map(reg_exps, fn re ->
        matches = Regex.scan(re, data)
        pattern_str = Regex.source(re)
        count = length(matches)
        "#{pattern_str} #{count}"
      end)

    end_len =
      data
      |> String.replace(~r/tHa[Nt]/, "<4>")
      |> String.replace(~r/aND|caN|Ha[DS]|WaS/, "<3>")
      |> String.replace(~r/a[NSt]|BY/, "<2>")
      |> String.replace(~r/<[^>]*>/, "|")
      |> String.replace(~r/\|[^|][^|]*\|/, "-")
      |> String.length()

    [
      "Initial length: #{initial_len}",
      "Cleaned length: #{cleaned_len}",
      "Final length: #{end_len}",
      "",
      "Pattern matches:"
    ] ++ results
    |> Enum.join("\n")
  end
end

