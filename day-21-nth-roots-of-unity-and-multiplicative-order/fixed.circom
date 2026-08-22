pragma circom 2.0.0;

template FixedDomainCheck() {
    signal input omega;
    signal output isValid;

    signal omega2;
    signal omega4;

    omega2 <== omega * omega;
    omega4 <== omega2 * omega2;

    omega4 === 1;

    omega2 + 1 === 0;

    isValid <== 1;

}

component main = FixedDomainCheck();