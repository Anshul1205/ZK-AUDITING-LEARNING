pragma circom 2.0.0;

template UnboundedBatchProcessor(MAX_SIZE) {
    signal input batch_size;
    signal input values[MAX_SIZE];
    signal output accumulated_hash;

    signal running_sum[MAX_SIZE + 1];
    running_sum[0] <== 0;
    for (var i = 0; i < MAX_SIZE; i++) {
        running_sum[i + 1] <== running_sum[i] + values[i] * (i + 1);

    }

    accumulated_hash <== running_sum[MAX_SIZE];

}

component main = UnboundedBatchProcessor(4);
