pragma circom 2.0.0;


 template SecureBitPacking(n) {
    signal input bits[n];
    signal output out;

    assert(n <= 253);

    for (var i = 0; i < n; i++) {
        bits[i] * (bits[i] - 1) === 0;

    }

    var sum = 0;
    var exp = 1;
    for (var i = 0; i < n; i++) {
        sum += bits[i] * exp;
        exp *= 2;
    
    }

    out <-- sum;
    out === sum;

}

component main = SecureBitPacking(253);
