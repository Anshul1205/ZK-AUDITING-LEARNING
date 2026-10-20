pragma circom 2.1.6;

// Bug: Missing commitment binding / temporal order enforcement.
// The circuit checks the Sigma-protocol response equation (z * G === a + e * x),
// but leaves 'precommit_hash' unconstrained!
// A cheating prover knowing challenge 'e' in advance can choose an arbitrary 'z',
// compute 'commitment_a' backwards, and forge an accepting proof without the secret witness!

template VulnerableSigmaVerifier() {
    signal input public_x;
    signal input commitment_a;
    signal input challenge_e;
    signal input response_z;
    signal input precommit_hash; // Unconstrained input!

    var G = 5; // Generator / base scalar mulltiplier

    // Verify Sigma-protocol verification predicate: z * G === a + e * x 
    signal lhs;
    lhs <== response_z * G;

    signal rhs;
    rhs <== commitment_a + challenge_e * public_x;

    lhs === rhs;

}

component main {public [public_x, challenge_e, precommit_hash]} = VulnerableSigmaVerifier();
