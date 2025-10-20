def pi_digits():
    n = 1000  # fixed number of digits

    i = 0
    k = 0
    d = 0
    k2 = 0
    d3 = 0
    d4 = 0

    tmp1 = 0
    tmp2 = 0
    acc = 0
    den = 1
    num = 1

    chr_0 = ord("0")
    result = ""

    while True:
        k += 1

        # nextTerm(k)
        k2 = k * 2 + 1
        acc += num * 2
        acc *= k2
        den *= k2
        num *= k

        if num > acc:
            continue

        # extractDigit(3)
        tmp1 = num * 3
        tmp2 = tmp1 + acc
        tmp1 = tmp2 // den
        d3 = tmp1 & 0xFFFFFFFF

        # extractDigit(4)
        tmp1 = num * 4
        tmp2 = tmp1 + acc
        tmp1 = tmp2 // den
        d4 = tmp1 & 0xFFFFFFFF

        if d3 != d4:
            continue

        d = d3

        result += chr(d + chr_0)
        i += 1

        if i % 10 == 0:
            result += f"\t:{i}\n"

        if i >= n:
            if i % 10 != 0:
                pad = 10 - (i % 10)
                result += " " * pad + f"\t:{i}\n"
            break

        # eliminateDigit(d)
        acc -= den * d
        acc *= 10
        num *= 10

    return result
