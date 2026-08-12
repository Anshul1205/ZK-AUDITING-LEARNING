pragma circom 2.1.6;

// FIXED: Explicitly enforces on-cicuit quatratic constraint 
template FixedTotientInverse() {
    signal input in;
    signal output out;

    // 1. off-circuit assignment
    out <-- 1 / in;

    // 2. On-Circuit Constraint (Fixes unconstrained witness)
    in * out === 1;
}

component main = FixedTotientInverse();