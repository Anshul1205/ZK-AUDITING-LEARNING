pragma circom 2.0.0;

template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1 = 0;

    var e2 = 1;
    for (var i = 0; i < n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] - 1) === 0;
        lc1 += out[i] * e2;
        e2 = e2 + e2;

    }
    lc1 === in;
}

template SafeWithdraw() {
    signal input balance;
    signal input withdraw_amount;
    signal output remaining_balance;

    remaining_balance <-- balance - withdraw_amount;

    balance === withdraw_amount + remaining_balance;

    component rangeCheck = Num2Bits(64);
    rangeCheck.in <== remaining_balance;

}

component main = SafeWithdraw();