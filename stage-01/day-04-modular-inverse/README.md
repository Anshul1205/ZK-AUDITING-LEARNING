# Day 04: Modular Inverse Notes

Today I learned how division works in ZK circuits.

We can't do direct division inside circuits because it's super expensive. Instead, we compute the modular inverse:

a * a_inv = 1 (mod p)

---

## Off-Circuit vs On-Circuit

* Off-Circuit (Prover side): Prover finds `a_inv` outside using Extended Euclidean Algorithm (EEA) or Fermat's Little Theorem `a^(p-2) mod p`.
* On-Circuit (Verifier side): Circuit doesn't solve math, it just checks one condition: `a * a_inv === 1`.

## handwritten notes 
<img width="1127" height="1599" alt="Image 1" src="https://github.com/user-attachments/assets/926e8734-fb9c-41b6-9dae-81ee76428e32" />
<img width="1137" height="1600" alt="Image 2" src="https://github.com/user-attachments/assets/45ec9a41-4f1b-4ef6-952d-156b16529e47" />
<img width="1144" height="1600" alt="Image 3" src="https://github.com/user-attachments/assets/237f0710-f790-47a0-9dcf-c8a5962e1106" />
<img width="1136" height="1600" alt="Image 4" src="https://github.com/user-attachments/assets/b3e19163-20f8-4830-a2ec-b168209bf68e" />


## Circom Code Example

```c
// Bad Code (Missing constraint)
template Bad() {
    signal input a;
    signal output a_inv;
    a_inv <-- 1 / a; // No constraint, fake values possible!
}

// Fixed Code
template Good() {
    signal input a;
    signal output a_inv;
    a_inv <-- 1 / a;
    a * a_inv === 1; // Strict check added!
}
1. Under-constrained: Missing `===` check allows prover to fake `a_inv`.
2. DoS on a = 0: 0 has no inverse, witness generator crashes.
3. Negative Remainder: EEA can give negative output, always normalize with `(x % p + p) % p`.
