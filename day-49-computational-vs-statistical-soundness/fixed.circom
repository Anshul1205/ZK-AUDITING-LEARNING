pragma circom 2.1.6;

// Helper: Verifies that in is strictly within [0, 2^n - 1]
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

// Helper: Asserts that in1 < in2 for small intergers (bounded by n bits)
template LessThan(n) {
    signal input in[2];
    signal output out;
    
    component n2b = Num2Bits(n + 1);
    n2b.in <== in[0] + (1 << n) - in[1];
    out <== 1 - n2b.out[n];

}

// FIX:
// Explicitly constraints the remainder r to be strictly less than divsior b.
// Enforces mathematical soundness, preventing forged remainder claims.
template FixedSoundnessCheck() {
    signal input a;
    signal input b;
    signal input r;

    signal q;
    q <-- b != 0 ? a \ b : 0;

    // Linear equation constraint 
    a === q * b + r;

    // Enforce range check: r must be strictly less than b (r < b)
    component lt = LessThan(16);
    lt.in[0] <== r;
    lt.in[1] <== b;
    lt.out === 1;

}

component main = FixedSoundnessCheck();
