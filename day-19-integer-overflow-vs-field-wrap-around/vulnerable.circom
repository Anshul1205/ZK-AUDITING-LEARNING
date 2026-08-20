pragma circom 2.0.0;

template VulnerableBalanceSum() {
    signal input balanceA;
    signal input balanceB;
    signal output total;

    total <== balanceA + balanceB;

}

component main = VulnerableBalanceSum();
