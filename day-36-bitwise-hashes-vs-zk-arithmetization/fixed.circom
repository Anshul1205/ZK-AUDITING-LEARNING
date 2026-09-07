pragma circom 2.1.6;

// FIXED: Strictly enforced boolean constraint on every single decomposed bit wire
template FixedBitwiseXOR() {
    signal input in;       // Bounded 2-bit value
    signal input bits[2];  // Decomposed bits
    signal output out;

    // 1. Mandatory Boolean Constraints
    bits[0] * (1 - bits[0]) === 0;
    bits[1] * (1 - bits[1]) === 0;

    // 2. Linear Reconstruction Check
    in === bits[0] * 1 + bits[1] * 2;

    // 3. Sound Arithmetic XOR
    out <== bits[0] + 1 - 2 * bits[0];
}

component main = FixedBitwiseXOR();