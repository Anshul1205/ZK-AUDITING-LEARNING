pragma circom 2.1.6;

template VulnerableMerkleNode() {
    signal input left;
    signal input right;
    signal output hash;

    signal sum;
    sum <== left + right;
    hash <== sum * sum;

}

component main = VulnerableMerkleNode();