pragma circom 2.1.6;

template VulnerableQuotientVerifier() {
    signal input P_gamma;
    signal input Q_gamma;
    signal input gamma;
    signal input remainder;

    signal output valid;

    signal gamma_sq <== gamma * gamma;
    signal gamma_4 <== gamma_sq * gamma_sq;
    signal Z_H <== gamma_4 - 1;

    signal quotient_term <== Q_gamma * Z_H;

    P_gamma === quotient_term + remainder;

    valid <== 1;

}

component main = VulnerableQuotientVerifier();