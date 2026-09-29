pragma circom 2.1.6;

// Helper: Canonical IsZero check enforcing that out is 1 iff in == 0
template IsZero() {
    signal input in;
    signal output out;
    signal inv <-- in != 0 ? 1 / in : 0;
    out <-- in == 0 ? 1 : 0;
    out * in === 0;
    in * inv === 1 - out;
}

// Fix: Strictly derive and constrain the zero-state selector.
// Preserves completeness for honest zero inputs while preventing unauthorized bypass.
template FixedCompletenessCheck() {
    signal input inputAmount;
    signal input expectedOutput;
    signal input isZero;

    // 1. Verify that claimed isZero matches the actual zero status of inputAmount
    component zeroChecker = IsZero();
    zeroChecker.in <== inputAmount;

    // Strict constraint: Claimed isZero MUST match actual computed zero status
    isZero === zeroChecker.out;

    // 2. Enforce legitimate state transition
    signal diff;
    diff <== expectedOutput - inputAmount * 2;

    signal check;
    check <== diff * (1 - isZero);
    check === 0;
}

component main = FixedCompletenessCheck();