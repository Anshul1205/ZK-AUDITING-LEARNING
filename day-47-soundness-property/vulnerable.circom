pragma circom 2.1.6;

// Bug: Under-constrained state transition breaking Soundness property.
// The developer calculate the transition delta using an assignment hint (<--),
// But forgets to enforce the sttrict quadratic equaltiy binding
// 'claimedNewBalance' to 'oldBalance + transferAmount'.
// An attacker can claim an arbitrary inflated balance (e.g. 99999) without failure!
template VulnerableSoundnessCheck() {
    signal input oldBalance;
    signal input transferAmount;
    signal input claimedNewBalance;

    // Calculation hint without R1CS constraint binding!
    signal delta;
    delta <-- claimedNewBalance - oldBalance;

    // VULNERABILITY;
    // Missing strict equality: delta === transferAmount (or claimedNewBalance === oldBalance + transferAmount)
    // The R1CS system has dim > 0 (free variable), allowing false statements to verify!

}
component main {public [claimedNewBalance]} = VulnerableSoundnessCheck();
