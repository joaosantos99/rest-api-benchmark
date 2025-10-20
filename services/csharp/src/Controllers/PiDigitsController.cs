using Microsoft.AspNetCore.Mvc;
using System.Numerics;

namespace CSharpBenchmark.Controllers;

[ApiController]
[Route("api")]
public class PiDigitsController : ControllerBase
{
    [HttpGet("pi-digits")]
    public IActionResult GetPiDigits()
    {
        const int n = 1000; // number of digits to compute

        int i = 0;
        int k = 0;
        int d = 0;
        int k2 = 0;
        int d3 = 0;
        int d4 = 0;

        BigInteger tmp1, tmp2;
        BigInteger acc = 0;
        BigInteger den = 1;
        BigInteger num = 1;

        BigInteger two = 2;
        BigInteger three = 3;
        BigInteger four = 4;
        BigInteger ten = 10;

        var result = new System.Text.StringBuilder();

        while (true)
        {
            k++;
            k2 = k * 2 + 1;

            // nextTerm(k)
            tmp1 = num * two;
            acc += tmp1;
            acc *= k2;
            den *= k2;
            num *= k;

            if (num > acc)
            {
                continue;
            }

            // extractDigit(3)
            tmp1 = num * three;
            tmp2 = tmp1 + acc;
            tmp1 = tmp2 / den;
            d3 = (int)(tmp1 & 0xFFFFFFFF);

            // extractDigit(4)
            tmp1 = num * four;
            tmp2 = tmp1 + acc;
            tmp1 = tmp2 / den;
            d4 = (int)(tmp1 & 0xFFFFFFFF);

            if (d3 != d4)
            {
                continue;
            }
            d = d3;

            result.Append((char)('0' + d));
            i++;

            if (i % 10 == 0)
            {
                result.Append($"\t:{i}\n");
            }

            if (i >= n)
            {
                if (i % 10 != 0)
                {
                    int pad = 10 - (i % 10);
                    result.Append(new string(' ', pad));
                    result.Append($"\t:{i}\n");
                }
                break;
            }

            // eliminateDigit(d)
            tmp1 = d;
            tmp1 *= den;
            acc -= tmp1;
            acc *= ten;
            num *= ten;
        }

        return Ok(result.ToString());
    }
}
