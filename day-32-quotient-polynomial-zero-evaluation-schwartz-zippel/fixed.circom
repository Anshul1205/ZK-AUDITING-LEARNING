pragma circom 2.1.6;

template FixedQuotientVerifier() {
    signal input P_gamma;
    signal input Q_gamma;
    signal input gamma;
    signal input remainder;

    signal output valid;

    remainder === 0;

    signal gamma_sq <== gamma * gamma;
    signal gamma_4 <== gamma_sq * gamma_sq;
    signal Z_H <== gamma_4 - 1;

    P_gamma === Q_gamma * Z_H;

    valid <== 1;

}

component main = FixedQuotientVerifier();