<?php

/**
 * Performs regex-redux benchmark test
 */
function regex_redux(): string
{
    $regExps = [
        '/agggtaaa|tttaccct/i',
        '/[cgt]gggtaaa|tttaccc[acg]/i',
        '/a[act]ggtaaa|tttacc[agt]t/i',
        '/ag[act]gtaaa|tttac[agt]ct/i',
        '/agg[act]taaa|ttta[agt]cct/i',
        '/aggg[acg]aaa|ttt[cgt]ccct/i',
        '/agggt[cgt]aa|tt[acg]accct/i',
        '/agggta[cgt]a|t[acg]taccct/i',
        '/agggtaa[cgt]|[acg]ttaccct/i'
    ];

    // Use a sample DNA sequence for testing since we can't read from stdin in a web context
    $sampleData = '
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
  ';

    $data = $sampleData;
    $initialLen = strlen($data);

    $data = preg_replace('/^>.*\n|\n/m', '', $data);
    $cleanedLen = strlen($data);

    $results = [];
    foreach ($regExps as $re) {
        $count = preg_match_all($re, $data, $matches);
        // Extract pattern source (remove delimiters and flags)
        $pattern = preg_replace('/^\/(.*)\/[a-z]*$/i', '$1', $re);
        $results[] = $pattern . ' ' . ($count !== false ? $count : 0);
    }

    $endLen = strlen(
        preg_replace('/\|[^|][^|]*\|/', '-',
            preg_replace('/<[^>]*>/', '|',
                preg_replace('/a[NSt]|BY/', '<2>',
                    preg_replace('/aND|caN|Ha[DS]|WaS/', '<3>',
                        preg_replace('/tHa[Nt]/', '<4>', $data)
                    )
                )
            )
        )
    );

    $output = [
        "Initial length: {$initialLen}",
        "Cleaned length: {$cleanedLen}",
        "Final length: {$endLen}",
        '',
        'Pattern matches:'
    ];
    $output = array_merge($output, $results);
    return implode("\n", $output);
}

?>

