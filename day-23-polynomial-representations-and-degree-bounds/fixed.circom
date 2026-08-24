pragma circom 2.1.6;

template FixedPolyEval() {
    signal input coeffs[3];
    signal input x;
    signal input expectedEval;

    signal xSquared;
    xSquared <== x * x;

    signal quadTerm;
    quadTerm <== coeffs[2] * xSquared;

    signal linearTerm;
    linearTerm <== coeffs[1] * x;

    signal fullEval;
    fullEval <== coeffs[0] + linearTerm + quadTerm;

    expectedEval === fullEval;

}

component main = FixedPolyEval();