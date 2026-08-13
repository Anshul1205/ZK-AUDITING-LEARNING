pragma circom 2.1.6;


template SecureBitDecomposition(n) {
    signal input e;
    signal output b[n];

    var sum = 0;

    // Off-circuit bit extraction
    for (var i = 0; i < n; i++) {
        b[i] <-- (e >> i) & 1;
    }

    // Reconstruction constraint
    for (var i = 0; i < n; i++) {
        sum += b[i] * (1 << i);
    }

    // Verifies that sum equals input e
    e === sum;

    // THE FIX: Strict Boolean Constraint enforcement!
    for (var i = 0; i < n; i++) {
        b[i] * (b[i] - 1) === 0;
    }
}

component main = SecureBitDecomposition(4);