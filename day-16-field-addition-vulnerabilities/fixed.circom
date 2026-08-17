pragma circom 2.1.6;

template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1 = 0;
    
    for (var i = 0; i < n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] - 1) === 0;
        lc1 += out[i] * 2**i;

    }
    lc1 === in;
}

template FixedBatchDeposit(n) {
    signal input deposits[n];
    signal input declared_total;
    signal output valid_sum;

    component rangeCheck[n];
    signal acc[n];

    for (var i = 0; i < n; i++) {
        rangeCheck[i] = Num2Bits (64);
        rangeCheck[i].in <== deposits[i];

    }
    
    acc[0] <== deposits[0];
    for (var i = 1; i < n; i++) {
        acc[i] <== acc[i-1] + deposits[i];

    }

    acc[n-1] === declared_total;
    valid_sum <== acc[n-1];

}

component main {public [declared_total]} = FixedBatchDeposit(2);