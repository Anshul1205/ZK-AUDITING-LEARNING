pragma circom 2.1.6;

// REMEDIATION: Strictly Enforces Permutation Matrix Invariants
// 1. Binary checks: P[i][j] * (1 - P[i][j]) === 0
// 2. Unit row sums: sum_j P[i][j] === 1
// 3. Unit column sums: sum_i P[i][j] === 1
// 4. Exact transformation: A2 === P * A1 * P^T

template FixedGraphIsomorphismVerifier() {
    signal input A1[3][3];
    signal input A2[3][3];
    signal input P[3][3];

    // 1. Enforce each entry is strictly binary (0 or 1)
    for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
            P[i][j] * (1 - P[i][j]) === 0;
        }
    }

    // 2. Enforce each row sums strictly to 1
    for (var i = 0; i < 3; i++) {
        P[i][0] + P[i][1] + P[i][2] === 1;
    }

    // 3. Enforce each column sums strictly to 1
    for (var j = 0; j < 3; j++) {
        P[0][j] + P[1][j] + P[2][j] === 1;
    }

    signal temp[3][3];
    signal prod1[3][3][3];
    signal prod2[3][3][3];

    // temp = P * A1
    for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
            for (var k = 0; k < 3; k++) {
                prod1[i][j][k] <== P[i][k] * A1[k][j];
            }
            temp[i][j] <== prod1[i][j][0] + prod1[i][j][1] + prod1[i][j][2];
        }
    }

    // Verify A2 == temp * P^T
    for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
            for (var k = 0; k < 3; k++) {
                prod2[i][j][k] <== temp[i][k] * P[j][k];
            }
            A2[i][j] === prod2[i][j][0] + prod2[i][j][1] + prod2[i][j][2];
        }
    }
}

component main {public [A1, A2]} = FixedGraphIsomorphismVerifier();