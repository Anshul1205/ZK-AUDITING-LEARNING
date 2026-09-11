pragma circom 2.1.6;

// Fix: Strictly enforces boolean constraint b_i * (1 - b_i) === 0 for each bit signal.
template ScalarMultFixed(nBits) {
    signal input scalar;
    signal input in_x;
    signal input in_y;

    signal output out_x;
    signal output out_y;

    signal bits[nBits];

    for (var i = 0; i < nBits; i++) {
        bits[i] <-- (scalar >> i) & 1;
        // Enforce binary domain: strictly 0 or 1
        bits[i] * (1 - bits[i]) === 0;
    }

    // Linear reconstruction check
    var sum = 0;
    for (var i = 0; i < nBits; i++) {
        sum += bits[i] * (2 ** i);
    }
    sum === scalar;

    signal acc_x[nBits + 1];
    signal acc_y[nBits + 1];

    acc_x[0] <== in_x;
    acc_y[0] <== in_y;

    for (var i = 0; i < nBits; i++) {
        acc_x[i + 1] <== acc_x[i] + bits[i] * in_x;
        acc_y[i + 1] <== acc_y[i] + bits[i] * in_y;
    }

    out_x <== acc_x[nBits];
    out_y <== acc_y[nBits];
}

component main = ScalarMultFixed(4);