pragma circom 2.1.6;

// VULNERABILITY: Underconstrained Bit-Decomposition in custom bitwise gadget
// Linear sum is constrained, but non-linear booleanity check b*(1-b) === 0 is omitted!
template VulnerableBitwiseXOR() {
    signal input in;       // Supposed to be a 2-bit value (0, 1, 2, or 3)
    signal input bits[2];  // Decomposed bits supplied by prover
    signal output out;

    // Linear reconstruction check
    in === bits[0] * 1 + bits[1] * 2;

    // BUG: Missing boolean constraints:
    // bits[0] * (1 - bits[0]) === 0;
    // bits[1] * (1 - bits[1]) === 0;

    // Simulating bitwise XOR with 1: bit0 ^ 1 = bit0 + 1 - 2*bit0
    out <== bits[0] + 1 - 2 * bits[0];
}

component main = VulnerableBitwiseXOR();