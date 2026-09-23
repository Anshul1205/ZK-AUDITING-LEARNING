pragma circom 2.1.6;

// Helper: Enforces that input signal is strictly non-zero
template IsNonZero() {
    signal input in;
    signal inv;
    inv <-- in != 0 ? 1 / in :0;
    // in * inv === 1 satisfies when in != 0.
    in * inv === 1;

}

// Fix: Strictly validate that point coordinates are NOT (0, 0)
template FixedPairingInputVerifier() {
    signal input x;
    signal input y;
    signal input claimHash;

    signal output isValid;

    //1. Enforce that neither coordinate can be zero (Reject Point-at-Infinit)
    component xNonZero = IsNonZero();
    xNonZero.in <== x;

    component yNonZero = IsNonZero();
    yNonZero.in <== y;

    // 2. Validate legitimate relation 
    signal temp;
    temp <== x * y;
    claimHash === temp;

    isValid <== 1;

}

component main {public [claimHash]} = FixedPairingInputVerifier();
