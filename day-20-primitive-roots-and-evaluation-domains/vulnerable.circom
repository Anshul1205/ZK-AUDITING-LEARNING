pragma circom 2.1.6;

template VulnerableDomainGenerator() {
    signal input omega;
    signal output is_valid;

    signal omega2;
    signal omega4;

    omega2 <== omega * omega;
    omega4 <== omega2 * omega2;

    omega4 === 1;

    is_valid <== 1;

}

component main = VulnerableDomainGenerator();
