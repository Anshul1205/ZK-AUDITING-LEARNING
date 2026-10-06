pragma circom 2.1.6;

// Bug: Missing boolean constraint on the interactive challange signal.
// In the Ali Baba / Color-Blind model, the verifier challenge MUST be strictly binary (0 ir 1).
// Without enforcing challenge * (1 - challenge) === 0, an attacker can inject non-binary field elements
// to forge arbitrary responses and bypass verification!
template VulnerableInteractiveVerifier() {
    signal input challenge; // Intended to be strictly 0 (Path A) or 1 (Path B)
    signal input secret;
    signal input response;

    // Expected reponse logic:
    // If challenge == 0 -> expected response = 10 (Public Path A constant)
    // If challenge == 1 -> expected response = secret (Path B unlocking witness)
    signal pathA_term;
    pathA_term <== (1 - challenge) * 10;

    signal pathB_term;
    pathB_term <== challenge * secret;

    // VULNERABILITY: Missing boolean check allos challenge injection (e.g. challenge  = 2)
    response === pathA_term + pathB_term;

}

component main {public [challenge, response]} = VulnerableInteractiveVerifier();
