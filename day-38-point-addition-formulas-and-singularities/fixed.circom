pragma circom 2.0.0;

template IsZero() {
    signal input in;
    signal output out;

    signal inv;
    inv <-- in != 0 ? 1 / in : 0;
    
    out <== -in * inv + 1;
    in * out === 0;

}

template FixedPointAdd() {
    signal input x1;
    signal input y1;
    signal input x2;
    signal input y2;
    signal input lambda;

    signal output x3;
    signal output y3;

    // Ensure x1 != x2 so denominator (x2 - x1) can never be zero
    signal diffX <== x2 - x1;
    component isZero = IsZero();
    isZero.in <== diffX;
    isZero.out === 0; // Strictly assert diff != 0

    // Enforce slope and target coordinates
    lambda * diffX === y2 - y1;

    x3 <== lambda * lambda - x1 - x2;
    y3 <== lambda * (x1 - x3) - y1;

}

component main = FixedPointAdd();