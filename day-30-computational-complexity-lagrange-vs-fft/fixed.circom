pragma circom 2.0.0;

template IsZero() {
    signal input in;
    signal output out;
    signal inv;

    inv <-- in != 0 ? 1 / in : 0;
    out <== -in * inv + 1;
    in * out === 0;
}

template BoundedBatchProcessor(MAX_CAP) {
    signal input batch_size;
    signal input values[MAX_CAP];
    signal output accumulated_hash;

    signal diff[MAX_CAP + 1];
    component is_zero[MAX_CAP + 1];
    signal sum_matches[MAX_CAP + 2];
    sum_matches[0] <== 0;

    for (var i = 0; i <= MAX_CAP; i++) {
        diff[i] <== batch_size - i;
        is_zero[i] = IsZero();
        is_zero[i].in <== diff[i];
        sum_matches[i + 1] <== sum_matches[i] + is_zero[i].out;
    }

    sum_matches[MAX_CAP + 1] === 1;

    signal running_sum[MAX_CAP + 1];
    running_sum[0] <== 0;

    for (var i = 0; i < MAX_CAP; i++) {
        running_sum[i + 1] <== running_sum[i] + values[i] * (i + 1);
    }

    accumulated_hash <== running_sum[MAX_CAP];
}

component main {public [batch_size]} = BoundedBatchProcessor(4);