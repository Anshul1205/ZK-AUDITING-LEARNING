pragma circom 2.1.6;

template SetMembershipFixed() {
    signal input x;

    signal diff1 <== x - 5;
    signal diff2 <== x - 10;
    signal diff3 <== x - 15;

    signal inter <== diff1 * diff2;
    0 === inter * diff3;


}

component main = SetMembershipFixed();
