#include "pi_digits.h"
#include <string>
#include <gmpxx.h>

crow::response pi_digits() {
    const int n = 1000; // number of digits to compute

    int i = 0;
    int k = 0;
    int d = 0;
    int k2 = 0;
    int d3 = 0;
    int d4 = 0;

    mpz_class tmp1, tmp2;
    mpz_class acc(0);
    mpz_class den(1);
    mpz_class num(1);

    mpz_class two(2);
    mpz_class three(3);
    mpz_class four(4);
    mpz_class ten(10);

    std::string result;

    while (true) {
        k++;
        k2 = k * 2 + 1;

        // nextTerm(k)
        tmp1 = num * two;
        acc += tmp1;
        acc *= k2;
        den *= k2;
        num *= k;

        if (num > acc) {
            continue;
        }

        // extractDigit(3)
        tmp1 = num * three;
        tmp2 = tmp1 + acc;
        tmp1 = tmp2 / den;
        d3 = tmp1.get_si();

        // extractDigit(4)
        tmp1 = num * four;
        tmp2 = tmp1 + acc;
        tmp1 = tmp2 / den;
        d4 = tmp1.get_si();

        if (d3 != d4) {
            continue;
        }
        d = d3;

        result += static_cast<char>('0' + d);
        i++;

        if (i % 10 == 0) {
            result += "\t:" + std::to_string(i) + "\n";
        }

        if (i >= n) {
            if (i % 10 != 0) {
                int pad = 10 - (i % 10);
                result += std::string(pad, ' ');
                result += "\t:" + std::to_string(i) + "\n";
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

    return crow::response(200, result);
}
