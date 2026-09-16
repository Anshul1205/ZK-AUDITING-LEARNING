pragma circom 2.1.6;

// VULNERABILITY:
// BN254 base field prime q > scalar field prime r.
// Developer checks the curve equation natively modulo r,
// completely ignoring validation of whether it's on genuine F_q!
// A fake point (x=1, y=2) passes modulo r easily.

template VulnerableCurveCheck() {
    signal input x;
    signal input y;
    signal input isValidFqPoint; 

    
    signal x2;
    signal x3;

    x2 <== x * x;
    x3 <== x2 * x;

    // Evaluates modulo r natively in Circom!
    y * y === x3 + 3;

}

component main = VulnerableCurveCheck();

