pragma circom 2.1.6;

// VULNERABILITY: Unconstrained Permutation Matrix
// The circuit checks A2 == P * A1 * P^T for 3-vertex graphs.
// BUG: Omits binary checks (P[i][j] * (1 - P[i][j]) === 0) and unit row/col sums.
// An attacker injects an all-zero matrix P = 0 to forge isomorphism between non-isomorphic graphs!

template VulnerableGraphIsomorphismVerifier() {
    signal input A1[3][3];
    signal input A2[3][3];
    signal input P[3][3];

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

    // A2 == temp * P^T
    for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
            for (var k = 0; k < 3; k++) {
                prod2[i][j][k] <== temp[i][k] * P[j][k];
            }
            A2[i][j] === prod2[i][j][0] + prod2[i][j][1] + prod2[i][j][2];
        }
    }
}

component main {public [A1, A2]} = VulnerableGraphIsomorphismVerifier();