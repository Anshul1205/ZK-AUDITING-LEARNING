pragma circom 2.1.6;

// PoC: Nullifier bypass via unconstrained public signal
template VulnerableNullifier() {
    signal input secret;
    signal input claimedNullifier;

    // Intermediate state calculation (e.g. state transition / dummy commitment)
    signal computedHash;
    computedHash <-- secret * secret + 7;

    // Constrainting secret computation internally 
    computedHash === secret * secret + 7;

    // VULNERABLILITY:
    // 'claimedNullifier' is declared as an input but never constrained against computedHash!
    // An attacker can pass any arbitrary value for claimedNUllifier without failing verification.

}

component main {public [claimedNullifier]} = VulnerableNullifier();
