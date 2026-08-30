pragma circom 2.1.6;


template FixedInterpolation() {
    signal input alpha;
    signal input x[3];
    signal input y[3];
    
    signal output out;

    // Basis 0
    signal num0;
    num0 <== (alpha - x[1]) * (alpha - x[2]);
    signal denom0;
    denom0 <-- (x[0] - x[1]) * (x[0] - x[2]);
    signal denom0_inv;
    denom0_inv <-- 1 / denom0;
    denom0 * denom0_inv === 1; 
    signal L0;
    L0 <== num0 * denom0_inv;
    signal term0;
    term0 <== y[0] * L0;

    // Basis 1
    signal num1;
    num1 <== (alpha - x[0]) * (alpha - x[2]);
    signal denom1;
    denom1 <-- (x[1] - x[0]) * (x[1] - x[2]);
    signal denom1_inv;
    denom1_inv <-- 1 / denom1;
    denom1 * denom1_inv === 1; 

    signal L1;
    L1 <== num1 * denom1_inv;
    signal term1;
    term1 <== y[1] * L1;

    // Basis 2
    signal num2;
    num2 <== (alpha - x[0]) * (alpha - x[1]);
    signal denom2;
    denom2 <-- (x[2] - x[0]) * (x[2] - x[1]);
    signal denom2_inv;
    denom2_inv <-- 1 / denom2;
    denom2 * denom2_inv === 1;
    signal L2;
    L2 <== num2 * denom2_inv;
    signal term2;
    term2 <== y[2] * L2;

    out <== term0 + term1 + term2;
}

component main = FixedInterpolation();