pragma circom 2.0.0;

template VulnerableWithdraw() {
    signal input balance;
    signal input withdraw_amount;
    signal output remaining_balance;

    remaining_balance <== balance - withdraw_amount;

}

component main = VulnerableWithdraw();