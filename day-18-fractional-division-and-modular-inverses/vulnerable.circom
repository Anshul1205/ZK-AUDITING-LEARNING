pragma circom 2.0.0;

template VulnerableDivision() {
    signal input a;
    signal input b;
    signal output out;

    out <-- b != 0 ? a / b : 0;

    out * b === a;

}

component main = VulnerableDivision();
