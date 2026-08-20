pragma circom 2.0.0;

template Num2Bits(n) {
    signal input in;
    signal output out[n];

    var lc = 0;
    var e2 = 1;
    for ( var i = 0; i < n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] - 1) === 0;
        lc += out[i] * e2;
        e2 = e2 + e2;

    }
    lc === in;

}

template FixedBalanceSum() {
    signal input balanceA;
    signal input balanceB;
    signal output total;
    
    component checkA = Num2Bits(64);
    checkA.in <== balanceA;

    component checkB = Num2Bits(64);
    checkB.in <== balanceB;

    total <== balanceA + balanceB;

}

component main = FixedBalanceSum();