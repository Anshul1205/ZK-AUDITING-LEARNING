pragma circom 2.1.6;

template FixedCosetDomainVerifier() {
    signal input g;
    signal input omega;
    signal input eval_point;
    signal output isVerified;


    signal w2;
    signal w4;
    w2 <== omega * omega;
    w4 <== w2 * w2;
    w4 === 1;

    signal w2_sub_1;
    signal w2_inv;
    w2_sub_1 <== w2 - 1;
    w2_inv <-- 1 / w2_sub_1;
    w2_inv * w2_sub_1 === 1;

    signal g2;
    signal g4;
    signal g4_sub_1;
    signal g4_inv;

    g2 <== g * g;
    g4 <== g2 * g2;
    g4_sub_1 <== g4 - 1;

    g4_inv <-- 1 / g4_sub_1;
    g4_inv * g4_sub_1 === 1;

    isVerified <== 1;


}

component main = FixedCosetDomainVerifier();