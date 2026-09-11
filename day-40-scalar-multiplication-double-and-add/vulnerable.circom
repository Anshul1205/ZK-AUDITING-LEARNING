pragma circom 2.1.6;

// Bug: Missing boolean constraint on bits (bits[i] * (1 - bits[i]) === 0).
// Prover can inject non-binary field elements to forge arbitrary scalar outputs!
template ScalarMultVulnerable(nBits) {
    signal input scalar;
    signal input in_x;
    signal input in_y;

    signal output out_x;
    signal output out_y;

    signal bits[nBits];

    // Hint decomposition
    for (var i = 0; i < nBits; i++) {
        bits[i] <-- (scalar >> i) & 1;
    }

    // Linear reconstruction check
    var sum = 0;
    for (var i = 0; i < nBits; i++) {
        sum += bits[i] * (2 ** i);
    }
    sum === scalar;

    // Accumulator using bits directly in multiplexer without boolean assertion
    signal acc_x[nBits + 1];
    signal acc_y[nBits + 1];

    acc_x[0] <== in_x;
    acc_y[0] <== in_y;

    for (var i = 0; i < nBits; i++) {
        // Multiplier assumes bits[i] is strictly 0 or 1
        acc_x[i + 1] <== acc_x[i] + bits[i] * in_x;
        acc_y[i + 1] <== acc_y[i] + bits[i] * in_y;
    }

    out_x <== acc_x[nBits];
    out_y <== acc_y[nBits];
}

component main = ScalarMultVulnerable(4);