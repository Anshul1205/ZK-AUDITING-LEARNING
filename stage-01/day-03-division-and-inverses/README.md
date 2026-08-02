# Day 03: Finite Field Division & Unconstrained Signal Vulnerabilities in Circom

## 📋 Overview
This repository documents my Day 03 learnings on the ZK Engineering roadmap. Today's focus was understanding how division works inside prime finite fields ($\mathbb{F}_p$) and analyzing how unconstrained helper signals in templates like `IsZero` can lead to critical proof-forgery vulnerabilities.

---

## 🧮 Core Theory: Division in Finite Fields ($\mathbb{F}_p$)

In Zero-Knowledge circuits (specifically Circom operating over $\mathbb{F}_p$), traditional division and floating-point decimals do not exist. Everything operates using integer arithmetic modulo a large prime $p$.

### 1. Multiplicative Inverse Definition
Instead of calculating $a / b$, a field division is executed by finding the **modular multiplicative inverse** of $b$, denoted as $b^{-1}$, such that:

$$b \cdot b^{-1} \equiv 1 \pmod p$$

Thus, field division is represented as:

$$a / b \equiv a \cdot b^{-1} \pmod p$$

### 2. Existence Condition & Fermat's Little Theorem
- A multiplicative inverse $b^{-1}$ exists **if and only if** $\gcd(b, p) = 1$.
- Since $p$ is a prime number in ZK protocols (e.g., BN254), every non-zero field element $b \neq 0$ is guaranteed to have a unique multiplicative inverse.
- By **Fermat's Little Theorem**, for any prime $p$ and $b \not\equiv 0 \pmod p$:

$$b^{p-1} \equiv 1 \pmod p \implies b \cdot b^{p-2} \equiv 1 \pmod p$$

Therefore:

$$b^{-1} \equiv b^{p-2} \pmod p$$

---

## ⚠️ The Vulnerability: Zero-Division & Unconstrained Signals

### The Problem
Since $0$ has no multiplicative inverse, circuits cannot directly perform `1 / in` when `in == 0`. Circom handles this using off-circuit witness assignment (`<--`) to compute a helper signal `inv`.

However, values assigned using `<--` are **NOT automatically constrained** on-circuit. If the developer forgets to enforce polynomial constraints using `===`, a malicious prover can inject arbitrary values into `inv` to forge fake proofs.

---
## Hand written notes 
<img width="899" height="1280" alt="Image 01" src="https://github.com/user-attachments/assets/9d16b227-767d-4540-95d5-538c71147bee" />
<img width="901" height="1280" alt="Image 02" src="https://github.com/user-attachments/assets/94f67ae8-74f5-4f1a-8fe0-1f683480cf0f" />
<img width="906" height="1280" alt="image 03" src="https://github.com/user-attachments/assets/b42427b6-a8d3-40da-a6f6-b699b804ab32" />
<img width="906" height="1280" alt="Image 4" src="https://github.com/user-attachments/assets/678bff32-9c94-4651-a4e4-f03b5576b5a2" />





## 💻 Code Implementation: Secure `IsZero` Template

Below is the complete, fully-constrained Circom implementation for checking if a signal is zero.

```circom
pragma circom 2.1.6;

template IsZero() {
    signal input in;
    signal output out;

    // Helper signal to store the multiplicative inverse
    signal inv;

    // 1. WITNESS GENERATION (Off-circuit computation)
    // If input is non-zero, calculate 1 / in.
    // If input is 0, assign 0 (since 0 has no inverse).
    inv <-- in != 0 ? 1 / in : 0;

    // 2. ON-CIRCUIT POLYNOMIAL CONSTRAINTS
    // Constraint A: If in != 0, then (in * inv) must equal 1.
    // If in == 0, then (0 * inv) forces out = -0 + 1 = 1.
    out <== -in * inv + 1;

    // Constraint B: Prevents prover from forging `inv` when `in == 0`.
    // Enforces that either `in` is 0 or `out` is 0.
    in * out === 0;
}

component main = IsZero();
