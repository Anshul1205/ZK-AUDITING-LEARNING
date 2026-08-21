pragma circom 2.1.6;


template FixedDomainGenerator() {
    signal input omega;
    signal output is_valid;

    signal omega2;
    signal omega4;

    omega2 <== omega * omega;
    omega4 <== omega2 * omega2;

    omega4 === 1;

    omega2 + 1 === 0;

    is_valid <== 1;

}

component main = FixedDomainGenerator();