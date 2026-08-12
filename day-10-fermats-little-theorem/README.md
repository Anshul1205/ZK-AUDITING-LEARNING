# Day 10: Point 1.1.3.1 - Fermat's Little Theorem & Fast Modular Inverse

## 📌 Core Concepts Covered
- **Fermat's Little Theorem (FLT) Statement:** For any prime $p$ and integer $a$ where $\gcd(a, p) = 1$:
  $$a^{p-1} \equiv 1 \pmod p$$
- **Modular Multiplicative Inverse Derivation:**
  $$a \cdot a^{p-2} \equiv a^{p-1} \equiv 1 \pmod p \implies a^{-1} \equiv a^{p-2} \pmod p$$
- **Execution Speed Trade-off:**
  - Extended Euclidean Algorithm (EEA): $O(\log(\min(a, p)))$ variable time steps.
  - Fermat's Exponentiation: $O(\log p)$ constant-time friendly steps (~254 operations for BN254 scalar field).

## ⚠️ ZK Auditor Security Angle & Vulnerability Vectors
- **Off-Circuit Execution:** $a^{p-2} \pmod p$ is computed OFF-CIRCUIT during witness generation (`<--`).
- **Unconstrained Inverse Bug:** If the ON-CIRCUIT verifier lacks the quadratic constraint $a \cdot a\_inv \equiv 1 \pmod p$, a prover can pass arbitrary fake inverse signals to forge proofs.
- **Zero-Input Edge Case:** $0^{p-2} \equiv 0 \pmod p$. Zero has no inverse. Unhandled $a = 0$ inputs allow bypassing zero-division restrictions.

## 🛡️ Remediation / The Fix
- Always enforce $a \cdot a\_inv === 1$ quadratic constraints on-circuit.
- Handle zero checks explicitly using `IsZero` guards before executing inverse logic.

## MY Handwritten Notes are Below
<img width="916" height="1280" alt="Image 01" src="https://github.com/user-attachments/assets/2a5b0bc1-f63e-4c88-9db3-2cf208ead88d" />
<img width="892" height="1280" alt="Image 02" src="https://github.com/user-attachments/assets/35fcee8f-7e4a-4a08-9fbf-ccd8e83e0733" />
<img width="908" height="1280" alt="Image 03" src="https://github.com/user-attachments/assets/e57d4d4d-194b-42fe-b393-67f9e02c058a" />
<img width="952" height="1280" alt="Image 04" src="https://github.com/user-attachments/assets/c6a27a41-5915-4fb1-8b56-d4fdc78978af" />

---

## 🛠️ Practical Implementation & Vulnerability Breakdown

### 🐛 Vulnerability Analysis (`vulnerable.circom`)
* **Root Cause:** The prover calculates the inverse off-circuit using `<--` assignment (`out <-- in^(p-2)`).
* **Security Exploit:** Missing `===` constraint creates an unconstrained witness vulnerability. An attacker can tamper with `witness.json` and inject an arbitrary forged value for `out`. The verifier will still accept the proof!

### 🛡️ Mitigation & Fix (`fixed.circom`)
* **Constraint Enforcement:** Added explicit quadratic constraint `in * out === 1;`.
* **Security Result:** Even if an attacker injects a false value in witness assignment, verification fails because `in * fake_out !== 1`.












