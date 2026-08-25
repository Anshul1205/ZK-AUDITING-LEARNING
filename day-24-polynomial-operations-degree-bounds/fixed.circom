pragma circom 2.1.6;

template PolyLinearCombinationFixed() {
    signal input p[3];
    signal input q[3];
    signal input c;

    signal output r[3];

    signal cq[3];

    for (var i =0; i < 3; i++) {
        cq[i] <== c * q[i];
        r[i] <== p[i] + cq[i];
    }
}

component main = PolyLinearCombinationFixed();