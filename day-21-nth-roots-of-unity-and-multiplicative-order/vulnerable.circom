pragma circom 2.0.0;

template VulnerableDomainCheck() {
    signal input omega;
    signal output isValid;

    signal omega2;
    signal omega4;

    omega2 <== omega * omega;
    omega4 <== omega2 * omega2;

    omega4 === 1;
    
    isValid  <== 1;

}

component main = VulnerableDomainCheck();