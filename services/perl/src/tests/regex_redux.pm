package Tests::RegexRedux;

use strict;
use warnings;

sub regex_redux {
    my @pattern_strings = (
        'agggtaaa|tttaccct',
        '[cgt]gggtaaa|tttaccc[acg]',
        'a[act]ggtaaa|tttacc[agt]t',
        'ag[act]gtaaa|tttac[agt]ct',
        'agg[act]taaa|ttta[agt]cct',
        'aggg[acg]aaa|ttt[cgt]ccct',
        'agggt[cgt]aa|tt[acg]accct',
        'agggta[cgt]a|t[acg]taccct',
        'agggtaa[cgt]|[acg]ttaccct'
    );

    my @reg_exps = map { qr/$_/i } @pattern_strings;

    # Use a sample DNA sequence for testing since we can't read from stdin in a web context
    my $sample_data = "
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

    my $data = $sample_data;
    my $initial_len = length($data);

    $data =~ s/^>.*\n|\n//mg;
    my $cleaned_len = length($data);

    my @results;
    for my $i (0..$#reg_exps) {
        my $re = $reg_exps[$i];
        my $pattern = $pattern_strings[$i];
        my @matches = ($data =~ /$re/g);
        my $count = scalar(@matches);
        push @results, "$pattern $count";
    }

    my $end_data = $data;
    $end_data =~ s/tHa[Nt]/<4>/g;
    $end_data =~ s/aND|caN|Ha[DS]|WaS/<3>/g;
    $end_data =~ s/a[NSt]|BY/<2>/g;
    $end_data =~ s/<[^>]*>/|/g;
    $end_data =~ s/\|[^|][^|]*\|/-/g;
    my $end_len = length($end_data);

    return join("\n",
        "Initial length: $initial_len",
        "Cleaned length: $cleaned_len",
        "Final length: $end_len",
        "",
        "Pattern matches:",
        @results
    );
}

1;

