import re

def regex_redux():
    """Perform regex pattern matching and replacements on DNA sequence data"""
    reg_exps = [
        re.compile(r'agggtaaa|tttaccct', re.IGNORECASE),
        re.compile(r'[cgt]gggtaaa|tttaccc[acg]', re.IGNORECASE),
        re.compile(r'a[act]ggtaaa|tttacc[agt]t', re.IGNORECASE),
        re.compile(r'ag[act]gtaaa|tttac[agt]ct', re.IGNORECASE),
        re.compile(r'agg[act]taaa|ttta[agt]cct', re.IGNORECASE),
        re.compile(r'aggg[acg]aaa|ttt[cgt]ccct', re.IGNORECASE),
        re.compile(r'agggt[cgt]aa|tt[acg]accct', re.IGNORECASE),
        re.compile(r'agggta[cgt]a|t[acg]taccct', re.IGNORECASE),
        re.compile(r'agggtaa[cgt]|[acg]ttaccct', re.IGNORECASE)
    ]

    # Use a sample DNA sequence for testing since we can't read from stdin in a web context
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

    data = sample_data
    initial_len = len(data)

    data = re.sub(r'^>.*\n|\n', '', data, flags=re.MULTILINE)
    cleaned_len = len(data)

    results = []
    for reg_exp in reg_exps:
        matches = reg_exp.findall(data)
        pattern_str = reg_exp.pattern
        results.append(f'{pattern_str} {len(matches)}')

    data = re.sub(r'tHa[Nt]', '<4>', data, flags=re.IGNORECASE)
    data = re.sub(r'aND|caN|Ha[DS]|WaS', '<3>', data, flags=re.IGNORECASE)
    data = re.sub(r'a[NSt]|BY', '<2>', data, flags=re.IGNORECASE)
    data = re.sub(r'<[^>]*>', '|', data)
    data = re.sub(r'\|[^|][^|]*\|', '-', data)
    end_len = len(data)

    return '\n'.join([
        f'Initial length: {initial_len}',
        f'Cleaned length: {cleaned_len}',
        f'Final length: {end_len}',
        '',
        'Pattern matches:',
        *results
    ])

