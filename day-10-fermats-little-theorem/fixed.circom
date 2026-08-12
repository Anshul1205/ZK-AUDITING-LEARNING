pragma circom 2.1.6;

// FIXED: Enforces quadratic constraint (in * out === 1)
template FixedInverse() {
    signal input in;
    signal output out;

    // 1. Off-circuit calculation
    out <-- in ** (21888242871839275222246405745257275088548364400416034343698204186575808495617 - 2);

    // 2. On-Circuit Constraint: Enforces that 'out' is indeed the valid multiplicative inverse
    in * out === 1;
}

component main = FixedInverse();