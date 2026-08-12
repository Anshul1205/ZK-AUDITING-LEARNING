pragma circom 2.1.6;

// VULNERABLE: Missing quadratic constraint enforcement (a * a_inv === 1)
template VulnerableInverse() {
    signal input in;
    signal output out;

    // Off-circuit witness generation
    // BUG: Missing on-circuit equality check
    out <-- in ** (21888242871839275222246405745257275088548364400416034343698204186575808495617 - 2);
}

component main = VulnerableInverse();