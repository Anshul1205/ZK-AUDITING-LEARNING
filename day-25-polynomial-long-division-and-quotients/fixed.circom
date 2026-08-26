pragma circom 2.1.6;

template FixedPolynomialDivision() {
    signal input p[4];
    signal input d[3];
    signal input q[2];
    signal input r[2];

    signal computed_p[4];

    r[0] === 0;
    r[1] === 0;

    signal m0;
    signal m1_1;
    signal m1_2;
    signal m2_1;
    signal m2_2;
    signal m3;

    m0 <== d[0] * q[0];
    computed_p[0] <== m0 + r[0];

    m1_1 <== d[0] * q[1];
    m1_2 <== d[1] * q[0];
    computed_p[1] <== m1_1 + m1_2 + r[1];

    m2_1 <== d[1] * q[1];
    m2_2 <== d[2] * q[0];
    computed_p[2] <== m2_1 + m2_2;

    m3 <== d[2] * q[1];
    computed_p[3] <== m3;

    for (var i = 0; i < 4; i++) {
        p[i] === computed_p[i];
    }
}

component main = FixedPolynomialDivision();