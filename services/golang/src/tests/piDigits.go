package tests

import (
	"fmt"
	"math/big"
	"net/http"
	"strings"
)

func PiDigits(w http.ResponseWriter, r *http.Request) {
	const n = 10000 // number of digits to compute
	i := 0
	k := 0
	d := 0
	var k2, d3, d4 int

	// big integers
	tmp1 := big.NewInt(0)
	tmp2 := big.NewInt(0)
	acc := big.NewInt(0)
	den := big.NewInt(1)
	num := big.NewInt(1)

	two := big.NewInt(2)
	three := big.NewInt(3)
	four := big.NewInt(4)
	ten := big.NewInt(10)

	var result strings.Builder

	for {
		k++
		k2 = k*2 + 1

		// nextTerm(k)
		tmp1.Mul(num, two)         					// tmp1 = num * 2
		acc.Add(acc, tmp1)         					// acc += tmp1
		acc.Mul(acc, big.NewInt(int64(k2))) // acc *= k2
		den.Mul(den, big.NewInt(int64(k2))) // den *= k2
		num.Mul(num, big.NewInt(int64(k)))  // num *= k

		if num.Cmp(acc) == 1 {
			continue
		}

		// extractDigit(3)
		tmp1.Mul(num, three)
		tmp2.Add(tmp1, acc)
		tmp1.Quo(tmp2, den)
		d3 = int(tmp1.Int64())

		// extractDigit(4)
		tmp1.Mul(num, four)
		tmp2.Add(tmp1, acc)
		tmp1.Quo(tmp2, den)
		d4 = int(tmp1.Int64())

		if d3 != d4 {
			continue
		}
		d = d3

		result.WriteByte(byte('0' + d))
		i++

		if i%10 == 0 {
			result.WriteString(fmt.Sprintf("\t:%d\n", i))
		}

		if i >= n {
			if i%10 != 0 {
				pad := 10 - (i % 10)
				result.WriteString(strings.Repeat(" ", pad))
				result.WriteString(fmt.Sprintf("\t:%d\n", i))
			}
			break
		}

		// eliminateDigit(d)
		tmp1.SetInt64(int64(d))
		tmp1.Mul(tmp1, den)
		acc.Sub(acc, tmp1) // acc -= den * d
		acc.Mul(acc, ten)
		num.Mul(num, ten)
	}

	fmt.Fprint(w, result.String())
}
