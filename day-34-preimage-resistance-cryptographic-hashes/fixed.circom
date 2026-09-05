pragma circom 2.0.0;

template SoundPreimageProof() {
    signal input preimage;
    signal input expectedHash;
    signal output computedHash;

    signal m2;
    m2 <== preimage * preimage;
    computedHash <== m2 * preimage + 5;

    computedHash === expectedHash;

}

component main {public [expectedHash]} = SoundPreimageProof();