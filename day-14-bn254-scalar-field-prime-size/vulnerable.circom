pragma circom 2.0.0;

template Vulnerable254BitPacking() {
    signal input bits[254];
    signal output out;

    for (var i = 0; i < 254; i++) {
        bits[i] * (bits[i] - 1) === 0;

    }

    var sum = 0;
    var exp = 1;
    for (var i = 0; i < 254; i++) {
        sum += bits[i] * exp;
        exp *= 2;

    }

    out <-- sum;
    out === sum;



}

component main = Vulnerable254BitPacking();