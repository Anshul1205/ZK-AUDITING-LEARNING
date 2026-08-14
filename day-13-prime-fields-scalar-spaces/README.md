# Day 13: Finite Prime Fields (F_p), Scalar vs Base Fields & Wrap-Around Vulnerabilities

## 📌 Overview
In zero-knowledge proof systems (SNARKs/STARKs), computation does not happen on arbitrary integer types (uint256, int64) or floating-point numbers. Instead, circuits evaluate polynomials over discrete Finite Prime Fields (F_p). Understanding the algebraic boundaries, wrap-around mechanics, and the two-field architecture (Scalar Field vs Base Field) is fundamental to catching critical ZK circuit vulnerabilities.

---

## 1. Why ZK Circuits Need Finite Prime Fields (F_p)

1. Exact & Lossless Math: Floating-point numbers introduce non-deterministic rounding and precision loss. Prime fields guarantee that every addition, subtraction, multiplication, and non-zero division is exact and invertible.
2. Polynomial Soundness (Schwartz-Zippel Lemma): Comparing two high-degree polynomials by evaluating them at a random scalar point r in F_p guarantees sound verification with an error probability bounded by d / p. In a 254-bit prime field, this error probability is cryptographically negligible (~2^-254).

---

## 2. Core Field Arithmetic & Strict Wrap-Around

Let a, b in F_p = {0, 1, 2, ..., p-1}:

| Operation | Arithmetic Formula | Behavior in F_p |
| :--- | :--- | :--- |
| Modular Addition | (a + b) mod p | Wraps if a + b >= p |
| Modular Subtraction | (a - b + p) mod p | No negative numbers; wraps through zero |
| Modular Multiplication | (a * b) mod p | Product is strictly bounded within [0, p-1] |
| Modular Inversion (Division) | a * b^-1 mod p | Computed via Fermat's Little Theorem: b^-1 = b^(p-2) mod p |

---

## 3. Two-Field Architecture: Scalar Field (F_r) vs Base Field (F_q)

In pairing-based SNARKs (e.g., BN254 / alt_bn128):

- Scalar Field (F_r): The circuit execution space. Every Circom wire, input signal, intermediate signal, and R1CS quadratic constraint natively lives in F_r.
- Base Field (F_q): The coordinate plane of the Elliptic Curve. The coordinates (x, y) of curve points satisfy y^2 = x^3 + ax + b mod q.

Prime Sizes in BN254:
q = 21888242871839275222246405745257275088696311157297823662689037894645226208583 (Base Field)
r = 21888242871839275222246405745257275088548364400416034343698204186575808495617 (Scalar Field)

Critical Fact: q > r. A raw Base Field coordinate x in F_q cannot fit directly onto a native Circom wire without wrapping modulo r. Hence, curve point operations inside circuits require Non-Native BigInt Emulation (Limb Decomposition).

---

## 4. Auditor Radar: Field-Level Vulnerabilities & Exploits

### A. Field Underflow (Negative Subtraction Bypass)
- Vulnerability: Circuits lack native inequality operators (<, >). Subtraction a - b when b > a automatically wraps to p - (b - a).
- Exploit: In withdrawal/balance circuits (rem_bal <== bal - withdraw), if the developer omits a range constraint, an attacker requests a withdrawal greater than their balance, producing a massive 254-bit positive balance (~2^254).
- Mitigation: Decompose results into bits using range-check templates (Num2Bits / LessThan) to enforce a >= b.

### B. Public Input Aliasing (Modulus Wrap-Around Injection)
- Vulnerability: Due to modular arithmetic, x ≡ x + k * p (mod p).
- Exploit: If a smart contract accepts a uint256 public input x and passes it to an on-chain SNARK verifier without checking x < p, an attacker submits x' = x + p. The contract views x' as a new unique nullifier, while the verifier reduces x' mod p = x, validating the proof and enabling double-spending.
- Mitigation: Always enforce require(x < p, "Input scalar out of field range") in Solidity verifier wrappers.

### C. Division by Zero Constraint Glitch
- Vulnerability: Division is computed off-circuit and constrained on-circuit via c * b === a.
- Exploit: If b = 0 and a = 0, the constraint reduces to c * 0 === 0, which is trivially satisfied by any arbitrary value of c.
- Mitigation: Enforce non-zero assertions on denominators or constrain division using strict inverse templates (IsZero).

- ## MY Handwritten Notes
<img width="898" height="1280" alt="Image 01" src="https://github.com/user-attachments/assets/a194094d-f75f-41c6-bfc9-57ab2e4ba258" />
<img width="915" height="1280" alt="Image 02" src="https://github.com/user-attachments/assets/80e98838-8a24-45a7-8301-76d768c26658" />
<img width="894" height="1280" alt="Image 03" src="https://github.com/user-attachments/assets/8bfeca37-c67a-4048-a919-a0976d260d7f" />
<img width="918" height="1280" alt="Image 04" src="https://github.com/user-attachments/assets/1fcf0e2c-de1b-4fdc-b704-53198362fc22" />






