pragma circom 2.1.6;

// Bug: Missing check for identity / point at infinity (0,0)
// Allows trival pairing / zero-commitment bypass!
template VulnerablePairingInputVerifier() {
    signal input x;
    signal input y;
    signal input claimHash;

    signal output isValid;

    // Developer check: Coordinate relation to claim
    // Missing non-zero constraints on x and y!
    signal temp;
    temp <== x * y;

    // An attacker passing x = 0, y = 0 forces temp = 0.
    // If claimHash = 0 is supplied, the constraint is trivially satisfied.
    claimHash === temp;

    isValid <== 1;

}

component main {public [claimHash]} = VulnerablePairingInputVerifier();
