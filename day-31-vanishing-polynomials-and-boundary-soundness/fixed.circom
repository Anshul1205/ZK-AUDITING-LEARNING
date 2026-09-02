pragma circom 2.1.6;

template FixedStateTransition() {
    signal input states[4];
    signal input expected_final_state;
    signal output valid;

    states[1] === states[0] * 2;
    states[2] === states[1] * 2;
    states[3] === expected_final_state;

    valid <== 1;
}

component main = FixedStateTransition();