pragma circom 2.0.0;

template Num2Bits256() {
    signal input in;
    signal output out[256];

    var lc = 0;
    var e2 = 1;
    for (var i = 0; i < 256; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] - 1) === 0;
        lc += out[i] * e2;
        e2 = e2 + e2;

    }
    lc === in;

}

template Bits2Num256() {
    signal input in[256];
    signal output out;
    
    var lc = 0;
    var e2 = 1;
    for (var i = 0; i < 256; i++) {
        lc += in[i] * e2;
        e2 = e2 + e2;

    }
    out <== lc;

}

template VulnerableEndianConverter() {
    signal input inscalar;
    signal output outscalar;

    component n2b = Num2Bits256();
    component b2n = Bits2Num256();

    n2b.in <== inscalar;

    for (var i = 0; i < 256; i++) {
        b2n.in[i] <== n2b.out[255 - i];

    }

    outscalar <== b2n.out;

}

component main = VulnerableEndianConverter();
