pragma circom 2.1.6;

template PolyLinearCombinationVulnerable() {
    signal input p[3];
    signal input q[3];
    signal input c;
    
    signal output r[3];

    for (var i = 0; i < 3; i++) {

        r[i] <-- p[i] + c * q[i];
    }

}

component main = PolyLinearCombinationVulnerable();