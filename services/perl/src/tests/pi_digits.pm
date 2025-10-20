package Tests::PiDigits;

use strict;
use warnings;
use Math::BigInt;

sub pi_digits {
    my $n = 1000; # number of digits to compute

    my $i = 0;
    my $k = 0;
    my $d = 0;
    my $k2 = 0;
    my $d3 = 0;
    my $d4 = 0;

    my $tmp1 = Math::BigInt->new(0);
    my $tmp2 = Math::BigInt->new(0);
    my $acc = Math::BigInt->new(0);
    my $den = Math::BigInt->new(1);
    my $num = Math::BigInt->new(1);

    my $two = Math::BigInt->new(2);
    my $three = Math::BigInt->new(3);
    my $four = Math::BigInt->new(4);
    my $ten = Math::BigInt->new(10);

    my $result = "";

    while (1) {
        $k++;
        $k2 = $k * 2 + 1;

        # nextTerm(k)
        $tmp1 = $num * $two;
        $acc += $tmp1;
        $acc *= $k2;
        $den *= $k2;
        $num *= $k;

        if ($num > $acc) {
            next;
        }

        # extractDigit(3)
        $tmp1 = $num * $three;
        $tmp2 = $tmp1 + $acc;
        $tmp1 = $tmp2 / $den;
        $d3 = $tmp1 & 0xFFFFFFFF;

        # extractDigit(4)
        $tmp1 = $num * $four;
        $tmp2 = $tmp1 + $acc;
        $tmp1 = $tmp2 / $den;
        $d4 = $tmp1 & 0xFFFFFFFF;

        if ($d3 != $d4) {
            next;
        }
        $d = $d3;

        $result .= chr(ord('0') + $d);
        $i++;

        if ($i % 10 == 0) {
            $result .= "\t:$i\n";
        }

        if ($i >= $n) {
            if ($i % 10 != 0) {
                my $pad = 10 - ($i % 10);
                $result .= " " x $pad;
                $result .= "\t:$i\n";
            }
            last;
        }

        # eliminateDigit(d)
        $tmp1 = $d;
        $tmp1 *= $den;
        $acc -= $tmp1;
        $acc *= $ten;
        $num *= $ten;
    }

    return $result;
}

1;
