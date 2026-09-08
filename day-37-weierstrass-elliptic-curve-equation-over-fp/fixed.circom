pragma circom 2.1.6;

// SECURE: Enforce that (x, y) strictly satisfies the short Weirstrass equation y^2 = x^3 + 3
template FixedPointProcessor() {
    signal input x;
    signal input y;
    signal output validPoint;

    signal y_sq;
    y_sq <== y * y;

    signal x_sq;
    x_sq <== x * x;

    signal x_cube;
    x_cube <== x_sq * x;

    // Strictly enforce the on-curve invariant: y^2 === x^3 + 3 (for a=0, b=3)
    y_sq === x_cube + 3;

    validPoint <== 1;

}

component main = FixedPointProcessor();
