const piDigits = () => {
  const n = 1000; // fixed number of digits

  let i = 0;
  let k = 0;
  let d = 0;
  let k2 = 0;
  let d3 = 0;
  let d4 = 0;

  let tmp1 = 0n;
  let tmp2 = 0n;
  let acc = 0n;
  let den = 1n;
  let num = 1n;

  const chr_0 = "0".charCodeAt(0);
  let result = "";

  for (;;) {
    k++;

    // nextTerm(k)
    k2 = k * 2 + 1;
    acc += num * 2n;
    acc *= BigInt(k2);
    den *= BigInt(k2);
    num *= BigInt(k);

    if (num > acc) continue;

    // extractDigit(3)
    tmp1 = num * 3n;
    tmp2 = tmp1 + acc;
    tmp1 = tmp2 / den;
    d3 = Number(tmp1) >>> 0;

    // extractDigit(4)
    tmp1 = num * 4n;
    tmp2 = tmp1 + acc;
    tmp1 = tmp2 / den;
    d4 = Number(tmp1) >>> 0;

    if (d3 !== d4) continue;
    d = d3;

    result += String.fromCharCode(d + chr_0);
    i++;

    if (i % 10 === 0) {
      result += `\t:${i}\n`;
    }

    if (i >= n) {
      if (i % 10 !== 0) {
        const pad = 10 - (i % 10);
        result += " ".repeat(pad) + `\t:${i}\n`;
      }
      break;
    }

    // eliminateDigit(d)
    acc -= den * BigInt(d);
    acc *= 10n;
    num *= 10n;
  }

  return result;
};

export default piDigits;
