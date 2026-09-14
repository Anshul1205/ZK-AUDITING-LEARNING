pragma circom 2.1.6;

template IsZero() {
    signal input in;
    signal output out;
    signal inv <-- in != 0 ? 1 / in : 0;
    out <-- in == 0 ? 1 : 0;
    out * in === 0;
    in * inv === 1 - out;
}

template FixedPointAddition() {
    signal input x1;
    signal input y1;
    signal input x2;
    signal input y2;

    signal output x3;
    signal output y3;

    signal diff_x <== x2 - x1;
    signal sum_y <== y1 + y2;

    signal isSameX <== IsZero()(diff_x);
    signal isOppositeY <== IsZero()(sum_y);

    // Points are inverses: P + (-P) = O
    signal isInverse <== isSameX * isOppositeY;

    // FIX: Reject Point at Infinity. This assert MUST FAIL on inverse inputs!
    isInverse === 0;

    signal safe_denom <== diff_x + isInverse * 1;
    signal inv_diff <-- 1 / safe_denom;
    inv_diff * safe_denom === 1;

    signal lambda <== (y2 - y1) * inv_diff;
    x3 <== lambda * lambda - x1 - x2;
    y3 <== lambda * (x1 - x3) - y1;
}

component main = FixedPointAddition();