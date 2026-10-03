pragma circom 2.1.6;

// Bug: Intermediate witness calculation marked as 'signal output' (Public Signal Leakage).
// In Circom, any 'signal output' is automatically placed input/instance vector!
// This exposes the secret intermediate calculation in cleartext on-chain, completely destroying Zero-Knowledge!
template VulnerableZKLeak() {
    signal input secretWitness;
    signal input salt;

    // VULNERABILITY:
    // Developer erroneously declares intermediateStep as signal output instead of internal private signal!
    signal output intermediateStep;
    signal output commitment;

    // Private computation exposed to public verifier transcript:
    intermediateStep <== secretWitness * secretWitness;

    // Commitment computation 
    commitment <== intermediateStep + salt;

}

component main {public [salt]} = VulnerableZKLeak();
