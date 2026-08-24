pragma circom 2.1.6;

template VulnerablePolyEval() {
    signal input coeffs[3];
    signal input x;
    signal input expectedEval;

    signal linearTerm;
    linearTerm <== coeffs[1] * x;

    expectedEval === coeffs[0] + linearTerm;

}
component main = VulnerablePolyEval();