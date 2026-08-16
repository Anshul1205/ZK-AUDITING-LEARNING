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

template FixedEndianConverter() {
    signal input inscalar;
    signal output outscalar;

    component n2b = Num2Bits256();
    component b2n = Bits2Num256();

    n2b.in <== inscalar;

    for (var byteIdx = 0; byteIdx < 32; byteIdx++) {
        var targetByteIdx = 31 - byteIdx;
        for (var bitIdx = 0; bitIdx < 8; bitIdx++) {
            b2n.in[targetByteIdx * 8 + bitIdx] <== n2b.out[byteIdx * 8 + bitIdx];

        }
    }
    outscalar <== b2n.out;

}

component main = FixedEndianConverter();