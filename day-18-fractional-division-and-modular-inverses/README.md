# Day 18: Fractional Division Replacement in Prime Fields & Modular Multiplicative Inverses

## Overview
In discrete finite prime fields ($\mathbb{F}_p$), traditional non-integer fractions (e.g., 0.5, 5/3) do not natively exist. Every value must strictly belong to the scalar space $\{0, 1, \dots, p-1\}$. As a result, fractional division is algebraically transformed into multiplication by a modular multiplicative inverse ($a \cdot b^{-1} \pmod p$). This day explores the foundational algebra, the critical differences between CPU integer division and field division, and the security exploit vectors introduced by unconstrained division constraints and zero denominators.

---

## 1. Non-Existence of Fractions & Modular Inverses
* **Discrete Field Boundary:** Finite fields contain no decimals or fractional real numbers.
* **Modular Multiplicative Inverse:** For any non-zero element $b \in \mathbb{F}_p$, its multiplicative inverse $b^{-1}$ satisfies:
  $$b \cdot b^{-1} \equiv 1 \pmod p$$
* **Fermat's Little Theorem Inversion:** In a prime field $\mathbb{F}_p$, the modular inverse is calculated algebraically via:
  $$b^{-1} \equiv b^{p-2} \pmod p$$
* **Division Transformation:** The operation $a / b$ is computed as:
  $$a / b \equiv a \cdot b^{-1} \pmod p$$

---

## 2. Integer Division (Truncation) vs. Field Division (Exact Inversion)
A major vulnerability vector in cross-domain systems (EVM to ZK) stems from conflicting division semantics:

* **EVM / CPU Truncation:** Division evaluates as $a = q \cdot b + r$, returning the floor quotient $q = \lfloor a/b \rfloor$ and discarding the remainder $r$.
  * Example in Solidity: `7 / 2 == 3` (Lossy).
* **Finite Field Inversion:** Division calculates exact algebraic inversion $a \cdot b^{-1} \pmod p$.
  * Example in $\mathbb{F}_{13}$: $7 / 2 \equiv 7 \cdot 7 = 49 \equiv 10 \pmod{13}$.
  * Verification: $10 \cdot 2 = 20 \equiv 7 \pmod{13}$.
* **Auditor Trap:** Non-divisible numbers in field division wrap around into massive $\approx 254$-bit scalars instead of truncating down to small integers.

---

## 3. Circom Division Mechanics: Witness Hint vs. Quadratic Constraint
Because non-linear division cannot be expressed directly as a Rank-1 constraint, Circom separates the operation into two distinct phases:

1. **Off-Circuit Witness Calculation (`<--`):**
   * The compiler/witness generator calculates $a \cdot b^{-1} \pmod p$ off-circuit.
   * Assigns the value to the output wire without generating R1CS constraints.
2. **On-Circuit Verification (`===`):**
   * Enforces the quadratic equality check: `out * b === a`.
   * Ensures the prover supplied the correct algebraic result.
3. **Missing Constraint Danger:** Using `<--` without an accompanying `===` leaves the output wire unconstrained, allowing arbitrary value injection by a malicious prover.

---

## 4. Exploit Analysis: Division by Zero ($b = 0$) & Balance Forgery
* **The Root Cause:** When division is constrained as `out * b === a`, setting $a = 0$ and $b = 0$ collapses the constraint to:
  $$\text{out} \cdot 0 === 0$$
* **Arbitrary Witness Injection:** Because any scalar multiplied by 0 yields 0, this equation is satisfied for *every* possible value of $\text{out} \in \mathbb{F}_p$.
* **Attack Scenario:** An attacker bypasses witness computation, injects an arbitrary value (e.g., 100,000,000 tokens) into the witness, and produces a valid cryptographic proof accepted by the on-chain verifier.

---

## 5. Auditor Remediation Checklist
* **Mandatory Non-Zero Checks:** Always enforce $b \neq 0$ using an inverse check (`b * inv_b === 1`) or dedicated non-zero assertion gadgets before performing division.
* **Quadratic Enforcement:** Never rely solely on `<--` for division; always pair it with the corresponding quadratic constraint (`out * b === a`).
* **Range Bounds for Integer Semantics:** If business logic requires truncated integer division rather than field division, enforce explicit quotient-remainder constraints ($a === q \cdot b + r$ with $r < b$) using range checks.

## My HandWritten Notes Below
<img width="897" height="1280" alt="Image 01" src="https://github.com/user-attachments/assets/f9ccee6e-578a-441a-9c12-6404584a85e7" />
<img width="656" height="1043" alt="Image 02" src="https://github.com/user-attachments/assets/576b903c-bea1-44f1-b1e4-8402dc2c494f" />
<img width="904" height="1280" alt="Image 03" src="https://github.com/user-attachments/assets/6285c5d2-5cae-4b32-8a62-22da9b3ab45c" />
<img width="864" height="1280" alt="Image 04" src="https://github.com/user-attachments/assets/4638dfff-a431-4f9e-a230-e21b300724fb" />












