# Day 16: Field Addition Vulnerabilities & Modular Wrap-Arounds

## Overview
An exploration into Finite Field addition mechanics (F_p), R1CS modular equivalence traps, the architectural gap between EVM 2^256 and BN254 prime modulus r, and real-world accumulator bypass exploits.

---

## 1. Finite Field Addition Mechanics & Ambiguity
In a prime field F_p, arithmetic addition does not trigger traditional CPU integer overflow; it maps directly to modular equivalence:
(a + b) mod p = a + b - k * p, where k in {0, 1}

* State Ambiguity: For any target state c, the R1CS identity a + b === c holds true for both:
  * Canonical Integer Addition (k = 0): a + b = c
  * Modular Wrap-Around (k = 1): a + b = c + p
* The Root Cause: Arithmetic circuits only evaluate the canonical remainder within [0, p-1]. Without explicit range constraints, the verifier cannot distinguish between a genuine small sum and a wrapped massive state.

---

## 2. EVM vs BN254 Modulus Architecture Mismatch

| Parameter | Ethereum EVM (uint256) | Circom BN254 Field Element |
| :--- | :--- | :--- |
| Native Modulus | mod 2^256 (Power-of-two) | mod r (254-bit prime) |
| Overflow Handling | Automatic Revert (Solidity 0.8+) | Silent Modular Wrap-Around |
| Upper Bound Limit | 2^256 - 1 | r - 1 ≈ 2.1888 * 10^75 |

The Dangerous Interoperability Gap:
Range Gap = [r, 2^256 - 1]

* Any value within this gap is considered safe and valid in Solidity uint256.
* When passed into a ZK proof verifier, the value silently reduces modulo r, causing unexpected logical branches and bypasses.

---

## 3. Exploit Scenario: Unchecked Accumulator Bypass

Vulnerable Circom Logic:
* A batch deposit circuit adds multiple deposit inputs into an accumulator signal without checking input bit ranges.
* Protocol sets a maximum batch deposit cap: declared_total = 1000.
* For n = 2, an attacker supplies:
  * deposits[0] = p - 500
  * deposits[1] = 1500
* Circuit computes:
  acc = (p - 500 + 1500) mod p = (p + 1000) mod p = 1000
* Constraint 1000 === 1000 evaluates to VALID, allowing the attacker to register a massive private balance while bypassing on-chain deposit limits.

---

## 4. Auditor 2-Tier Mitigation Shield

1. Circuit Level (Bit-Bounding):
   * Constrain all input signals and intermediate accumulators using Num2Bits(n) such that cumulative additions are mathematically guaranteed to stay below the prime boundary: sum(Max(a_i)) < p.

2. Solidity Level (Public Input Validation):
   * Enforce scalar field boundary checks on all public inputs before verifier execution:
     require(input < r, "Scalar field overflow");

## My Handwritten Notes

<img width="899" height="1280" alt="Image 01" src="https://github.com/user-attachments/assets/4a8dc5e7-a4f7-404b-86c7-9e12aa2c9fb6" />
<img width="866" height="1280" alt="Image 02" src="https://github.com/user-attachments/assets/803f2bb4-8fb3-4acc-a086-c37403d4676e" />
<img width="908" height="1280" alt="Image 03" src="https://github.com/user-attachments/assets/c65347d1-1f83-4aff-b608-09fddcc7021d" />
<img width="853" height="1280" alt="Image 04" src="https://github.com/user-attachments/assets/4c8268d0-9952-4520-a3f5-af18c131ca84" />











     
