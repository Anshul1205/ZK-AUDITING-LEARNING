pragma circom 2.1.6;

template VulnerableEqualityCheck() {
    signal input a;
    signal input b;
    signal input raw_challenge;

    signal challenge_bit;
    signal diff;
    signal eval_check;

    challenge_bit <-- raw_challenge & 1;
    challenge_bit * (challenge_bit - 1) === 0;

    diff <== a - b;
    eval_check <== diff * challenge_bit;

    eval_check === 0;
}

component main = VulnerableEqualityCheck();