pragma circom 2.0.0;

template VulnerablePointAdd() {
    signal input x1;
    signal input y1;
    signal input x2;
    signal input y2;
    signal input lambda; // Adversary can inject arbitrary lambda when x1 == x2

    signal output x3;
    signal output y3;

    // Flawed slope constraint: Collapses to lambda * 0 === 0 when x1 == x2 and y1 == y2
    lambda * (x2 - x1) === y2 - y1;

    // Target coordinates bound to lambda
    x3 <== lambda * lambda - x1 - x2;
    y3 <== lambda * (x1 - x3) - y1;

}

component main = VulnerablePointAdd();
