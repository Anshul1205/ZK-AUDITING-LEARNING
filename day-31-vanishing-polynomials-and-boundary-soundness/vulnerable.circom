pragma circom 2.1.6;


template VulnerableStateTransition() {
    signal input states[4];
    signal input expected_final_state;
    signal output valid;

    states[1] === states[0] * 2;
    states[2] === states[1] * 2;


    valid <== 1;
}

component main = VulnerableStateTransition();