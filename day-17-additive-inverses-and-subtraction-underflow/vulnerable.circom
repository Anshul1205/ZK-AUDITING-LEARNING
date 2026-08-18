pragma circom 2.1.6;

template VulnerableWithdraw() {
    signal input current_balance;
    signal input withdraw_amount;
    signal output new_balance;

    new_balance <-- current_balance - withdraw_amount;

    current_balance === new_balance + withdraw_amount;

}

component main = VulnerableWithdraw();