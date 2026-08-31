pragma circom 2.1.6;

template PointToCoeffVulnerable() {
    signal input x[3];
    signal input y[3];

    signal output a[3];
    

    a[0] <-- 1;
    a[1] <-- 2;
    a[2] <-- 0;

    signal x_sq[2];
    signal term1[2];
    signal term2[2];

    for (var i = 0; i < 2; i++) {
        x_sq[i] <== x[i] * x[i];
        term1[i] <== a[1] * x[i];
        term2[i] <== a[2] * x_sq[i];

        y[i] === a[0] + term1[i] + term2[i];

    }
}

component main = PointToCoeffVulnerable();
