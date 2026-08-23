pragma circom 2.1.6;

template VulnerableCosetDomainVerifier() {
    signal input g;
    signal input omega;
    signal input eval_point;
    signal output isValidCosetPoint;

    signal w2;
    signal w4;
    w2 <== omega * omega;
    w4 <== w2 * w2;
    w4 === 1;

    isValidCosetPoint <-- 1;
    isValidCosetPoint === 1;

}

component main = VulnerableCosetDomainVerifier();