pragma circom 2.0.0;
 
 template InsecureInverse() {
    signal input a;
    signal output a_inv;

    // OFF Circuit calcualtions using Fermat's Little Theorem
    a_inv <-- a != 0 ? a ** (21888242871839275222246405745257275088548364400416034343698204186575808495617 - 2) : 0;

    // Vulnerability: On circuit quadratic constraint!
    // The Fix: Enforce Constraint On-Circuit!
    a * a_inv === 1;
    
    
   
 }

 component main = InsecureInverse();
