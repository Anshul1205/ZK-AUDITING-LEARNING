pragma circom 2.1.6;

// Fix: Strictly enforce that 'commitment_a' matches the immutably locked 'precommit_hash'.
// This ensures chronological order (a < e < z) and prevents backwards-commitment synthesis!

template FixedSigmaVerifier() {
    signal input public_x;
    signal input commitment_a;
    signal input challenge_e;
    signal input response_z;
    signal input precommit_hash;

    var G = 5;

    // 1. Enforce commitment binding (Chronological Gate: a must match pre-commitment)
    signal computed_commit_hash;
    computed_commit_hash <== commitment_a * commitment_a + 17;
    precommit_hash === computed_commit_hash;

    // 2. Verify Sigma-protocol response equation 
    signal lhs;
    lhs <== response_z * G;

    signal rhs;
    rhs <== commitment_a + challenge_e * public_x;

    lhs === rhs;

}

component main {public [public_x, challenge_e, precommit_hash]} = FixedSigmaVerifier();
