pragma circom 2.1.6;

// Vulnerable: Computes inverse using Euler's Totient but misses quadratic constraint
template VulnerableTotientInverse() {
    signal input in;
    signal output out;

    // off-circuit witness generation via Euler's Totient
    out <-- in ** 18; // Example for phi(n) = 18 off-circuit computation 

}

component main = VulnerableTotientInverse();