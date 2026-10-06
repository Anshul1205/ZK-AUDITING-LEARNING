pragma circom 2.1.6;

// Fix: Strictly enforces quadratic boolean constraint on the chllenge signal.
// Rejects any non-binary challenge injection attempt!
template FixedInteractiveVerifier() {
    signal input challenge;
    signal input secret;
    signal input response;

    // REMEDIATION: Enforce that challenge is strictly binary: 0 or 1
    challenge * (1 - challenge) === 0;

    signal pathA_term;
    pathA_term <== (1 - challenge) * 10;

    signal pathB_term;
    pathB_term <== challenge * secret;

    response === pathA_term + pathB_term;

}

component main {public [challenge, response]} = FixedInteractiveVerifier();
