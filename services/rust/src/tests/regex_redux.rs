use axum::response::Response;
use regex::Regex;

pub async fn handler() -> Response<String> {
    let reg_exps = vec![
        Regex::new(r"(?i)agggtaaa|tttaccct").unwrap(),
        Regex::new(r"(?i)[cgt]gggtaaa|tttaccc[acg]").unwrap(),
        Regex::new(r"(?i)a[act]ggtaaa|tttacc[agt]t").unwrap(),
        Regex::new(r"(?i)ag[act]gtaaa|tttac[agt]ct").unwrap(),
        Regex::new(r"(?i)agg[act]taaa|ttta[agt]cct").unwrap(),
        Regex::new(r"(?i)aggg[acg]aaa|ttt[cgt]ccct").unwrap(),
        Regex::new(r"(?i)agggt[cgt]aa|tt[acg]accct").unwrap(),
        Regex::new(r"(?i)agggta[cgt]a|t[acg]taccct").unwrap(),
        Regex::new(r"(?i)agggtaa[cgt]|[acg]ttaccct").unwrap(),
    ];

    let pattern_strings = vec![
        "agggtaaa|tttaccct",
        "[cgt]gggtaaa|tttaccc[acg]",
        "a[act]ggtaaa|tttacc[agt]t",
        "ag[act]gtaaa|tttac[agt]ct",
        "agg[act]taaa|ttta[agt]cct",
        "aggg[acg]aaa|ttt[cgt]ccct",
        "agggt[cgt]aa|tt[acg]accct",
        "agggta[cgt]a|t[acg]taccct",
        "agggtaa[cgt]|[acg]ttaccct",
    ];

    // Use a sample DNA sequence for testing since we can't read from stdin in a web context
    let sample_data = r"
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

    let mut data = sample_data.to_string();
    let initial_len = data.len();

    let re = Regex::new(r"(?m)^>.*\n|\n").unwrap();
    data = re.replace_all(&data, "").to_string();
    let cleaned_len = data.len();

    let mut results = Vec::new();
    for (i, re) in reg_exps.iter().enumerate() {
        let matches: Vec<&str> = re.find_iter(&data).map(|m| m.as_str()).collect();
        let count = matches.len();
        results.push(format!("{} {}", pattern_strings[i], count));
    }

    data = Regex::new(r"tHa[Nt]").unwrap().replace_all(&data, "<4>").to_string();
    data = Regex::new(r"aND|caN|Ha[DS]|WaS").unwrap().replace_all(&data, "<3>").to_string();
    data = Regex::new(r"a[NSt]|BY").unwrap().replace_all(&data, "<2>").to_string();
    data = Regex::new(r"<[^>]*>").unwrap().replace_all(&data, "|").to_string();
    data = Regex::new(r"\|[^|][^|]*\|").unwrap().replace_all(&data, "-").to_string();
    let end_len = data.len();

    let mut output = format!(
        "Initial length: {}\nCleaned length: {}\nFinal length: {}\n\nPattern matches:\n",
        initial_len, cleaned_len, end_len
    );
    output.push_str(&results.join("\n"));
    output.push('\n');

    Response::new(output)
}

