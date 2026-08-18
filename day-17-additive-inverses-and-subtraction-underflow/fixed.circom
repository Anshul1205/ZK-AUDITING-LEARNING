pragma circom 2.1.6;

template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1 =0;

    var e2 = 1;
    for (var i = 0; i < n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] - 1) === 0;
        lc1 += out[i] * e2;
        e2 = e2 + e2;

    }
    
    lc1 === in;

}

template LessThan(n) {
    assert(n <= 252);
    signal input in[2];
    signal output out;

    component n2b = Num2Bits(n + 1);
    n2b.in <== in[0] + (1 << n) - in[1];

    out <== 1 - n2b.out[n];

}

template FixedWithdraw(n) {
    signal input current_balance;
    signal input withdraw_amount;
    signal output new_balance;
    
    component lt = LessThan(n);
    lt.in[0] <== current_balance;
    lt.in[1] <== withdraw_amount;
    lt.out === 0;

    new_balance <-- current_balance - withdraw_amount;
    current_balance === new_balance + withdraw_amount;

    component n2b = Num2Bits(n);
    n2b.in <== new_balance;

}

component main = FixedWithdraw(64);