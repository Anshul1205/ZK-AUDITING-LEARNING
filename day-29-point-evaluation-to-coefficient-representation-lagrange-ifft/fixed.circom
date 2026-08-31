pragma circom 2.1.6;

template DistinctCheck() {
    signal input in1;
    signal input in2;
    signal diff;
    signal inv;

    diff <== in1 - in2;
    inv <-- diff != 0 ? 1 / diff : 0;
    diff * inv === 1;

}

template  PointToCoeffFixed() {
    signal input x[3];
    signal input y[3];

    signal output a[3];

    component check01 = DistinctCheck();
    check01.in1 <== x[0]; 
    check01.in2 <== x[1];

    component check12 = DistinctCheck();
    check12.in1 <== x[1];
    check12.in2 <== x[2];

    component check02 = DistinctCheck();
    check02.in1 <== x[0];
    check02.in2 <== x[2];

    a[0] <-- 1;
    a[1] <-- 2;
    a[2] <-- 0;

    signal x_sq[3];
    signal term1[3];
    signal term2[3];
    
    for (var i = 0; i < 3; i++) {
        x_sq[i] <== x[i] * x[i];
        term1[i] <== a[1] * x[i];
        term2[i] <== a[2] * x_sq[i];

        y[i] === a[0] + term1[i] + term2[i];

    }


}

component main = PointToCoeffFixed();
