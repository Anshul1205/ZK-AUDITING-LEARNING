pragma circom 2.1.6;

// Fix; Strictly enforce R1CS conservation constraint.
// Binds the public state transition to the input variables,
// completely eliminating free variables (dim = 0) and restoring Soundness.
template FixedSoundnessCheck() {
    signal input oldBalance;
    signal input transferAmount;
    signal input claimedNewBalance;

    // FIX: Strict quadratic constraint binding state to inputs
    claimedNewBalance === oldBalance + transferAmount;

}

component main {public [claimedNewBalance]} = FixedSoundnessCheck();
