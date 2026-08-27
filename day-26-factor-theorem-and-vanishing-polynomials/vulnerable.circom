pragma circom 2.1.6;

template SetMembershipVulnerable() {
    signal input x;
    signal diff1;
    signal diff2;
    signal diff3;
    signal inter;

    diff1 <-- x - 5;
    diff2 <-- x - 10;
    diff3 <-- x - 15;

    inter <-- diff1 * diff2;
    0 === inter;

}

component main = SetMembershipVulnerable();