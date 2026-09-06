pragma circom 2.1.6;

template FixedMerkleNode() {
    signal input left;
    signal input right;
    signal output hash;

    signal tag;
    tag <== 1;

    signal sum;
    sum <== tag + left + right;
    hash <== sum * sum;


}

component main = FixedMerkleNode();
