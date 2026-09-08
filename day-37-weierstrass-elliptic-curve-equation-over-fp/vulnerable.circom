pragma circom 2.1.6;

// VULNERABLITTY: Accepts point coordinates without verifying they lie on y^2 = x^3 + 3
template VulnerablePointProcessor() {
    signal input x;
    signal input y;
    signal output validPoint;

    // Dummy computation using the coordinates
    signal x_sq;
    x_sq <== x * x;

    // Missing: y^2 === x^3 + 3 check!
    validPoint <== 1;

}

component main = VulnerablePointProcessor();










