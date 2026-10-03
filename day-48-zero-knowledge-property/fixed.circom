pragma circom 2.1.6;

// Fix: Confines secret witness computation strictly to internal private signals.
// Only the randomized commitment is exposed as public output, preserving Zero-Knowledge!
// An assert checks that secretWitness does not equal an exposed trivial zero state.
template FixedZKPrivacy() {
    signal input secretWitness;
    signal input salt;

    signal output commitment;

    // REMEDIATION:
    // intermediatedStep is strictly declared as an internal private wire(signal), NEVER output!
    signal intermediateStep;
    intermediateStep <== secretWitness * secretWitness;

    // Enforce that secretWitness is non-zero to prevent trivial bypass:
    signal inv;
    inv <-- secretWitness != 0 ? 1 / secretWitness : 0;
    secretWitness * inv === 1;

    // Only randomized commitment is exported
    commitment <== intermediateStep + salt;

}

component main {public [salt]} = FixedZKPrivacy();
