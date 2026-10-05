pragma circom 2.1.6;

// VULNERABILITY
// Developer assumes that relying on unconstrained hint-based reduction provides sound verification.
// Without an explicit constraint binding the qoutient and remainder within valid ranges,
// a cheating prover can exploit computational leeway to satisfy the equation with and arbitrary remainder!

template VulnerableSoundnessCheck() {
    signal input a;
    signal input b;
    signal input r; // Claimed remainder (a % b)

    // Intermediate hint-only quotient computation 
    signal q;
    q <-- b != 0 ? a \ b : 0;

    // Incomplete constraint: Only checks linear combination a === q * b + r
    // Bug: Missing range assertion on r (r < b) and r >=0!
    // A prover can supply an invalid r >= b and still satisfy the linear constraint.
    a === q * b + r;

}

component main = VulnerableSoundnessCheck();
