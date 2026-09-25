pragma circom 2.1.6;

// PoC Fix: Strictly enforce equality constraint on public nullifier
template FixedNullifier() {
    signal input secret;
    signal input claimedNullifier;

    // Intermediate state calculation 
    signal computedHash;
    computedHash <-- secret * secret + 7;

    // Constraining secret computation internally 
    computedHash === secret * secret + 7;

    // REMEDIATION:
    // Strictly bind the public claimedNullifer to the internal computed state!
    claimedNullifier === computedHash;

}

component main {public [claimedNullifier]} = FixedNullifier();
