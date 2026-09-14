pragma circom 2.1.6;

// Bug: Unchecked Point Inversion Addition causes Prover Crash (0 * inv === 1 DoS)
template VulnerablePointAddition() {
    signal input x1;
    signal input y1;
    signal input x2;
    signal input y2;

    signal output x3;
    signal output y3;

    signal diff_x <== x2 - x1;
    signal diff_y <== y2 - y1;

    // Prover bypasses zero-division crash using a fallback inverse
    signal inv <-- diff_x != 0 ? 1 / diff_x : 0;
    
    // Vulnerability: Prover successfully generates an invalid witness!
    signal lambda <== diff_y * inv;

    signal lambda_sq <== lambda * lambda;
    x3 <== lambda_sq - x1 - x2;

    signal x_diff <== x1 - x3;
    y3 <== lambda * x_diff - y1;
}

component main = VulnerablePointAddition();