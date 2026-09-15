pragma circom 2.1.6;

template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1 = 0;

    for (var i = 0; i < n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] - 1) === 0;
        lc1 += out[i] * (1 << i);

    }
    lc1 === in;

}

// Fix: Strictly enforce Num2Bits(64) on every limb.
// Prevents limb inflation and guarantess limbs stay strictly inside [0, 2^64 - 1].
template NonNativeLimbFixed() {
    signal input limb0;
    signal input limb1;
    signal input expectedTotal;

    component check0 = Num2Bits(64);
    check0.in <== limb0;

    component check1 = Num2Bits(64);
    check1.in <== limb1;

    signal reconstructed;
    var SHIFT_64 = 18446744073709551616; // 2^64
    reconstructed <== limb0 + limb1 * SHIFT_64;

    reconstructed === expectedTotal;

}

component main = NonNativeLimbFixed();
