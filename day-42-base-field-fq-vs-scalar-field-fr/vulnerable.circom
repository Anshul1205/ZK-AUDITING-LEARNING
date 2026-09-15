pragma circom 2.1.6;

// Bug: Missing Num2Bits range checks on BigInt limbs.
// Wires live in Scaler Field Fr, but limbs represent Base Field Fq / BigInt.
// Unchecked limbs allow values >= 2^64 to cause silent modulo r wrap-around (aliasing).
template NonNativeLimbVulnerable() {
    signal input limb0;
    signal input limb1;
    signal input expectedTotal;

    // Linear reconstruction: Value = limb0 + limb1 * 2^64
    signal reconstructed;
    var SHIFT_64 = 18446744073709551616; // 2^64
    reconstructed <== limb0 + limb1 * SHIFT_64;

    // Directly equality check in Scaler Field Fr
    reconstructed === expectedTotal;

}

component main = NonNativeLimbVulnerable();
