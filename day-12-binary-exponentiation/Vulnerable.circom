pragma circom 2.1.6;


template InsecureBitDecomposition(n) {
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

   }

component main = InsecureBitDecomposition(4);