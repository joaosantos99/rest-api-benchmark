package tests

import (
	"fmt"
	"net/http"
	"regexp"
	"strings"
)

func RegexRedux(w http.ResponseWriter, r *http.Request) {
	regExps := []*regexp.Regexp{
		regexp.MustCompile(`(?i)agggtaaa|tttaccct`),
		regexp.MustCompile(`(?i)[cgt]gggtaaa|tttaccc[acg]`),
		regexp.MustCompile(`(?i)a[act]ggtaaa|tttacc[agt]t`),
		regexp.MustCompile(`(?i)ag[act]gtaaa|tttac[agt]ct`),
		regexp.MustCompile(`(?i)agg[act]taaa|ttta[agt]cct`),
		regexp.MustCompile(`(?i)aggg[acg]aaa|ttt[cgt]ccct`),
		regexp.MustCompile(`(?i)agggt[cgt]aa|tt[acg]accct`),
		regexp.MustCompile(`(?i)agggta[cgt]a|t[acg]taccct`),
		regexp.MustCompile(`(?i)agggtaa[cgt]|[acg]ttaccct`),
	}

	// Use a sample DNA sequence for testing since we can't read from stdin in a web context
	sampleData := `
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
  `

	data := sampleData
	initialLen := len(data)

	re := regexp.MustCompile(`(?m)^>.*\n|\n`)
	data = re.ReplaceAllString(data, "")
	cleanedLen := len(data)

	patternStrings := []string{
		"agggtaaa|tttaccct",
		"[cgt]gggtaaa|tttaccc[acg]",
		"a[act]ggtaaa|tttacc[agt]t",
		"ag[act]gtaaa|tttac[agt]ct",
		"agg[act]taaa|ttta[agt]cct",
		"aggg[acg]aaa|ttt[cgt]ccct",
		"agggt[cgt]aa|tt[acg]accct",
		"agggta[cgt]a|t[acg]taccct",
		"agggtaa[cgt]|[acg]ttaccct",
	}

	results := make([]string, 0, len(regExps))
	for i, re := range regExps {
		matches := re.FindAllString(data, -1)
		count := len(matches)
		results = append(results, fmt.Sprintf("%s %d", patternStrings[i], count))
	}

	data = regexp.MustCompile(`tHa[Nt]`).ReplaceAllString(data, "<4>")
	data = regexp.MustCompile(`aND|caN|Ha[DS]|WaS`).ReplaceAllString(data, "<3>")
	data = regexp.MustCompile(`a[NSt]|BY`).ReplaceAllString(data, "<2>")
	data = regexp.MustCompile(`<[^>]*>`).ReplaceAllString(data, "|")
	data = regexp.MustCompile(`\|[^|][^|]*\|`).ReplaceAllString(data, "-")
	endLen := len(data)

	fmt.Fprintf(w, "Initial length: %d\nCleaned length: %d\nFinal length: %d\n\nPattern matches:\n%s\n",
		initialLen, cleanedLen, endLen, strings.Join(results, "\n"))
}

