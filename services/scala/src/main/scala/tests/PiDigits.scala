import java.math.BigInteger

object PiDigits {
  def piDigits(): String = {
    val n = 1000 // number of digits to compute

    var i = 0
    var k = 0
    var d = 0
    var k2 = 0
    var d3 = 0
    var d4 = 0

    var tmp1: BigInteger = null
    var tmp2: BigInteger = null
    var acc = BigInteger.ZERO
    var den = BigInteger.ONE
    var num = BigInteger.ONE

    val two = BigInteger.valueOf(2)
    val three = BigInteger.valueOf(3)
    val four = BigInteger.valueOf(4)
    val ten = BigInteger.valueOf(10)

    val result = new StringBuilder()

    while (true) {
      k += 1
      k2 = k * 2 + 1

      // nextTerm(k)
      tmp1 = num.multiply(two)
      acc = acc.add(tmp1)
      acc = acc.multiply(BigInteger.valueOf(k2))
      den = den.multiply(BigInteger.valueOf(k2))
      num = num.multiply(BigInteger.valueOf(k))

      if (num.compareTo(acc) > 0) {
        // continue
      } else {
        // extractDigit(3)
        tmp1 = num.multiply(three)
        tmp2 = tmp1.add(acc)
        tmp1 = tmp2.divide(den)
        d3 = tmp1.intValue() & 0xFFFFFFFF

        // extractDigit(4)
        tmp1 = num.multiply(four)
        tmp2 = tmp1.add(acc)
        tmp1 = tmp2.divide(den)
        d4 = tmp1.intValue() & 0xFFFFFFFF

        if (d3 != d4) {
          // continue
        } else {
          d = d3
          result.append(('0' + d).toChar)
          i += 1

          if (i % 10 == 0) {
            result.append(s"\t:$i\n")
          }

          if (i >= n) {
            if (i % 10 != 0) {
              val pad = 10 - (i % 10)
              result.append(" " * pad)
              result.append(s"\t:$i\n")
            }
            return result.toString()
          }

          // eliminateDigit(d)
          tmp1 = BigInteger.valueOf(d)
          tmp1 = tmp1.multiply(den)
          acc = acc.subtract(tmp1)
          acc = acc.multiply(ten)
          num = num.multiply(ten)
        }
      }
    }

    result.toString()
  }
}
