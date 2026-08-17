pragma circom 2.1.6;

template VulnerableBatchDeposit(n) {
    signal input deposits[n];
    signal input declared_total;
    signal output valid_sum;

    signal acc[n];
    acc[0] <== deposits[0];
    for (var i = 1; i < n; i++) {
        acc[i] <== acc[i-1] + deposits[i];

    }
    
    acc[n-1] === declared_total;
    valid_sum <== acc[n-1];

}

component main { public [declared_total]} = VulnerableBatchDeposit(2);