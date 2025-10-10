use axum::response::Response;
use num_bigint::BigInt;

pub async fn handler() -> Response<String> {
    const N: usize = 10_000; // number of digits to compute

    let mut i = 0;
    let mut k = 0;
    let mut d;
    let mut k2;
    let mut d3;
    let mut d4;

    // Big integers
    let mut tmp1;
    let mut tmp2;
    let mut acc = BigInt::from(0);
    let mut den = BigInt::from(1);
    let mut num = BigInt::from(1);

    let two = BigInt::from(2);
    let three = BigInt::from(3);
    let four = BigInt::from(4);
    let ten = BigInt::from(10);

    let mut result = String::new();

    loop {
        k += 1;
        k2 = k * 2 + 1;

        // nextTerm(k)
        tmp1 = &num * &two; // tmp1 = num * 2
        acc = &acc + &tmp1; // acc += tmp1
        acc = &acc * BigInt::from(k2); // acc *= k2
        den = &den * BigInt::from(k2); // den *= k2
        num = &num * BigInt::from(k); // num *= k

        if &num > &acc {
            continue;
        }

        // extractDigit(3)
        tmp1 = &num * &three;
        tmp2 = &tmp1 + &acc;
        tmp1 = &tmp2 / &den;
        d3 = tmp1.to_string().parse::<i32>().unwrap_or(0);

        // extractDigit(4)
        tmp1 = &num * &four;
        tmp2 = &tmp1 + &acc;
        tmp1 = &tmp2 / &den;
        d4 = tmp1.to_string().parse::<i32>().unwrap_or(0);

        if d3 != d4 {
            continue;
        }
        d = d3;

        result.push(char::from_digit(d as u32, 10).unwrap());
        i += 1;

        if i % 10 == 0 {
            result.push_str(&format!("\t:{}\n", i));
        }

        if i >= N {
            if i % 10 != 0 {
                let pad = 10 - (i % 10);
                result.push_str(&" ".repeat(pad));
                result.push_str(&format!("\t:{}\n", i));
            }
            break;
        }

        // eliminateDigit(d)
        tmp1 = BigInt::from(d);
        tmp1 = &tmp1 * &den;
        acc = &acc - &tmp1; // acc -= den * d
        acc = &acc * &ten;
        num = &num * &ten;
    }

    Response::new(result)
}
