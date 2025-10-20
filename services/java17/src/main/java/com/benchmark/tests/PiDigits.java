package com.benchmark.tests;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import java.io.IOException;
import java.io.OutputStream;
import java.math.BigInteger;

public class PiDigits implements HttpHandler {
    @Override
    public void handle(HttpExchange exchange) throws IOException {
        final int n = 1000; // number of digits to compute

        int i = 0;
        int k = 0;
        int d = 0;
        int k2 = 0;
        int d3 = 0;
        int d4 = 0;

        BigInteger tmp1, tmp2;
        BigInteger acc = BigInteger.ZERO;
        BigInteger den = BigInteger.ONE;
        BigInteger num = BigInteger.ONE;

        BigInteger two = BigInteger.valueOf(2);
        BigInteger three = BigInteger.valueOf(3);
        BigInteger four = BigInteger.valueOf(4);
        BigInteger ten = BigInteger.valueOf(10);

        StringBuilder result = new StringBuilder();

        while (true) {
            k++;
            k2 = k * 2 + 1;

            // nextTerm(k)
            tmp1 = num.multiply(two);
            acc = acc.add(tmp1);
            acc = acc.multiply(BigInteger.valueOf(k2));
            den = den.multiply(BigInteger.valueOf(k2));
            num = num.multiply(BigInteger.valueOf(k));

            if (num.compareTo(acc) > 0) {
                continue;
            }

            // extractDigit(3)
            tmp1 = num.multiply(three);
            tmp2 = tmp1.add(acc);
            tmp1 = tmp2.divide(den);
            d3 = tmp1.intValue() & 0xFFFFFFFF;

            // extractDigit(4)
            tmp1 = num.multiply(four);
            tmp2 = tmp1.add(acc);
            tmp1 = tmp2.divide(den);
            d4 = tmp1.intValue() & 0xFFFFFFFF;

            if (d3 != d4) {
                continue;
            }
            d = d3;

            result.append((char)('0' + d));
            i++;

            if (i % 10 == 0) {
                result.append("\t:").append(i).append("\n");
            }

            if (i >= n) {
                if (i % 10 != 0) {
                    int pad = 10 - (i % 10);
                    for (int j = 0; j < pad; j++) {
                        result.append(" ");
                    }
                    result.append("\t:").append(i).append("\n");
                }
                break;
            }

            // eliminateDigit(d)
            tmp1 = BigInteger.valueOf(d);
            tmp1 = tmp1.multiply(den);
            acc = acc.subtract(tmp1);
            acc = acc.multiply(ten);
            num = num.multiply(ten);
        }

        String response = result.toString();
        exchange.getResponseHeaders().set("Content-Type", "text/plain");
        exchange.sendResponseHeaders(200, response.length());
        OutputStream os = exchange.getResponseBody();
        os.write(response.getBytes());
        os.close();
    }
}
