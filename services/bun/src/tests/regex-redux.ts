const regexRedux = () => {
  const regExps = [
    /agggtaaa|tttaccct/ig,
    /[cgt]gggtaaa|tttaccc[acg]/ig,
    /a[act]ggtaaa|tttacc[agt]t/ig,
    /ag[act]gtaaa|tttac[agt]ct/ig,
    /agg[act]taaa|ttta[agt]cct/ig,
    /aggg[acg]aaa|ttt[cgt]ccct/ig,
    /agggt[cgt]aa|tt[acg]accct/ig,
    /agggta[cgt]a|t[acg]taccct/ig,
    /agggtaa[cgt]|[acg]ttaccct/ig
  ];

  // Use a sample DNA sequence for testing since we can't read from stdin in a web context
  const sampleData = `
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
  `;

  let data = sampleData;
  const initialLen = data.length;

  data = data.replace(/^>.*\n|\n/mg, '');
  const cleanedLen = data.length;

  const results = [];
  for (let j = 0; j < regExps.length; j++) {
    const re = regExps[j];
    const m = data.match(re);
    results.push(`${re.source} ${m ? m.length : 0}`);
  }

  const endLen = data
    .replace(/tHa[Nt]/g, '<4>')
    .replace(/aND|caN|Ha[DS]|WaS/g, '<3>')
    .replace(/a[NSt]|BY/g, '<2>')
    .replace(/<[^>]*>/g, '|')
    .replace(/\|[^|][^|]*\|/g, '-')
    .length;

  return new Response([
    `Initial length: ${initialLen}`,
    `Cleaned length: ${cleanedLen}`,
    `Final length: ${endLen}`,
    '',
    'Pattern matches:',
    ...results
  ].join('\n'));
};

export default regexRedux;

