<?php

function pi_digits(): string
{
    $n = 1000; // number of digits to compute

    $i = 0;
    $k = 0;
    $d = 0;
    $k2 = 0;
    $d3 = 0;
    $d4 = 0;

    $tmp1 = 0;
    $tmp2 = 0;
    $acc = 0;
    $den = 1;
    $num = 1;

    $two = 2;
    $three = 3;
    $four = 4;
    $ten = 10;

    $result = "";

    while (true) {
        $k++;
        $k2 = $k * 2 + 1;

        // nextTerm(k)
        $tmp1 = $num * $two;
        $acc += $tmp1;
        $acc *= $k2;
        $den *= $k2;
        $num *= $k;

        if ($num > $acc) {
            continue;
        }

        // extractDigit(3)
        $tmp1 = $num * $three;
        $tmp2 = $tmp1 + $acc;
        $tmp1 = intval($tmp2 / $den);
        $d3 = $tmp1 & 0xFFFFFFFF;

        // extractDigit(4)
        $tmp1 = $num * $four;
        $tmp2 = $tmp1 + $acc;
        $tmp1 = intval($tmp2 / $den);
        $d4 = $tmp1 & 0xFFFFFFFF;

        if ($d3 != $d4) {
            continue;
        }
        $d = $d3;

        $result .= chr(ord('0') + $d);
        $i++;

        if ($i % 10 == 0) {
            $result .= "\t:$i\n";
        }

        if ($i >= $n) {
            if ($i % 10 != 0) {
                $pad = 10 - ($i % 10);
                $result .= str_repeat(" ", $pad);
                $result .= "\t:$i\n";
            }
            break;
        }

        // eliminateDigit(d)
        $tmp1 = $d;
        $tmp1 *= $den;
        $acc -= $tmp1;
        $acc *= $ten;
        $num *= $ten;
    }

    return $result;
}

?>
