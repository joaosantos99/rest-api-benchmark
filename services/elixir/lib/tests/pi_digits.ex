defmodule ElixirBenchmark.Tests.PiDigits do
  @moduledoc false

  def handler do
    n = 1000 # number of digits to compute

    pi_digits_loop(n, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, "")
  end

  defp pi_digits_loop(n, i, _k, _d, _k2, _d3, _d4, _tmp1, _tmp2, _acc, _den, _num, result) when i >= n do
    if rem(i, 10) != 0 do
      pad = 10 - rem(i, 10)
      result <> String.duplicate(" ", pad) <> "\t:#{i}\n"
    else
      result
    end
  end

  defp pi_digits_loop(n, i, k, d, _k2, d3, d4, _tmp1, _tmp2, acc, den, num, result) do
    k = k + 1
    k2 = k * 2 + 1

    # nextTerm(k)
    tmp1 = num * 2
    acc = acc + tmp1
    acc = acc * k2
    den = den * k2
    num = num * k

    if num > acc do
      pi_digits_loop(n, i, k, d, k2, d3, d4, tmp1, 0, acc, den, num, result)
    else
      # extractDigit(3)
      tmp1 = num * 3
      tmp2 = tmp1 + acc
      tmp1 = div(tmp2, den)
      d3 = rem(tmp1, 0x100000000)

      # extractDigit(4)
      tmp1 = num * 4
      tmp2 = tmp1 + acc
      tmp1 = div(tmp2, den)
      d4 = rem(tmp1, 0x100000000)

      if d3 != d4 do
        pi_digits_loop(n, i, k, d, k2, d3, d4, tmp1, tmp2, acc, den, num, result)
      else
        d = d3
        result = result <> <<(48 + d)>>
        i = i + 1

        result = if rem(i, 10) == 0 do
          result <> "\t:#{i}\n"
        else
          result
        end

        if i >= n do
          pi_digits_loop(n, i, k, d, k2, d3, d4, tmp1, tmp2, acc, den, num, result)
        else
          # eliminateDigit(d)
          tmp1 = d
          tmp1 = tmp1 * den
          acc = acc - tmp1
          acc = acc * 10
          num = num * 10
          pi_digits_loop(n, i, k, d, k2, d3, d4, tmp1, tmp2, acc, den, num, result)
        end
      end
    end
  end
end
