pragma circom 2.1.6;

// Bug: Unconstrained zero-check bypass signal breaking completeness/soundness boundary.
// To handle completeness for legitimate zero-value paths, the developer adds an 'isZero'
// selector to bypass the rate check, but leaves 'isZero' completely unconstrained!
// An attacker passes a non-zero input with a fake output and sets isZero = 1 to bypass checks.
template VulnerableCompletenessCheck() {
    signal input inputAmount;
    signal input expectedOutput;
    signal input isZero; // Vulnerability: Unconstrained bypass signal!

    // Expected business relation: expectedOutput must equal inputAmount * 2
    signal diff;
    diff <== expectedOutput - inputAmount * 2;

    // If isZero == 1, (1 - isZero) becomes 0, trivially satisfying the constraint
    signal check;
    check <== diff * (1 - isZero);
    check === 0;
}

component main = VulnerableCompletenessCheck();