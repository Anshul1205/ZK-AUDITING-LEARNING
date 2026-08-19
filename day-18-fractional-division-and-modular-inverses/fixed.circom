pragma circom 2.0.0;

template IsZero() {
    signal input in;
    signal output out;

    signal inv;
    inv <-- in != 0 ? 1 / in : 0;

    out <-- -in * inv + 1;
    in * out === 0;

}

template FixedDivision() {
    signal input a;
    signal input b;
    signal output out;

    component isZero = IsZero();
    isZero.in <== b;

    isZero.out === 0;

    out <-- a / b;
    out * b === a;

}

component main = FixedDivision();