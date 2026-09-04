pragma circom 2.1.6;


template FixedEqualityCheck() {
    signal input a;
    signal input b;
    signal input raw_challenge;

    signal diff;
    diff <== a - b;
    diff === 0;

    signal challenge_used;
    challenge_used <== raw_challenge * 1;
}

component main = FixedEqualityCheck();