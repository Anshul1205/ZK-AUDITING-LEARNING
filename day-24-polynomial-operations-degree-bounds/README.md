# Day 24: Computing Polynomial Addition, Scalar Multiplication, and Degree Bounds in F_p[X]

## 1. Overview & Core Concepts
In Zero-Knowledge proof systems (e.g., PLONK, Marlin, STARKs), circuit constraints and execution traces are represented as polynomials over finite fields. Efficiently manipulating these polynomials while maintaining cryptographic soundness requires strict tracking of degree evolution and operational bounds.

---

## 2. Polynomial Arithmetic & Degree Evolution Rules

### A. Polynomial Addition ($P + Q$)
Adding two polynomials over finite field $\mathbb{F}_p$:
$$S(X) = P(X) + Q(X) = \sum (a_i + b_i \pmod p) X^i$$

* **Degree Bound Rule:**
  $$\deg(P + Q) \le \max(\deg P, \deg Q)$$
* **Leading Coefficient Cancellation Edge Case:** If $\deg(P) = \deg(Q)$ and the leading coefficients satisfy $a_d + b_d \equiv 0 \pmod p$, the leading term cancels out, causing a strict degree collapse: $\deg(P + Q) < \max(\deg P, \deg Q)$.

### B. Scalar Multiplication ($c \cdot P$)
Scaling a polynomial by a non-zero field element $c \in \mathbb{F}_p^*$:
$$M(X) = c \cdot P(X) = \sum (c \cdot a_i \pmod p) X^i$$

* **Degree Preservation:**
  $$\deg(c \cdot P) = \deg(P) \quad \text{for all } c \neq 0$$

### C. Polynomial Multiplication ($P \cdot Q$)
Multiplying two polynomials via Cauchy convolution:
$$M(X) = P(X) \cdot Q(X) = \sum c_k X^k \quad \text{where } c_k = \sum_{i+j=k} (a_i \cdot b_j \pmod p)$$

* **Strict Degree Growth:** Because $\mathbb{F}_p$ is an integral domain (no non-trivial zero-divisors), leading coefficients never vanish:
  $$\deg(P \cdot Q) = \deg(P) + \deg(Q)$$

---

## 3. Random Linear Combinations (Constraint Batching)
To batch multiple polynomial identities ($C_1(X), C_2(X), \dots, C_m(X)$) into a single master constraint identity without inflating verification complexity:
$$C_{\text{batched}}(X) = \sum_{i=1}^{m} \alpha^{i-1} \cdot C_i(X)$$
* $\alpha \in \mathbb{F}_p$ is a random challenge generated via the Fiat-Shamir heuristic.
* **Degree Bound:** The batched polynomial retains the degree of the highest constraint: $\deg(C_{\text{batched}}) = \max_i(\deg C_i)$.

---

## 4. ZK Security Exploits & Auditor Checklist

* **Degree Inflation & Setup Overflows:** If degree bounds are not verified during polynomial arithmetic, higher-degree terms can exceed the Trusted Setup limit ($S_{\max}$ in KZG) or cause aliasing over undersized domains.
* **Leading Term Cancellation Trap:** Protocols expecting fixed degree outputs can crash or enter unconstrained verification branches if opposing leading coefficients cancel out to zero.
* **Unconstrained Signal Assignment Bug:** In Circom/R1CS implementations, computing polynomial arithmetic using unconstrained operators (`<--`) without locking them with equality constraints (`===` or `<==`) allows malicious provers to inject arbitrary polynomial coefficients.

---

## 5. Summary Lock
* **Core Concept:** Addition preserves or lowers degree; multiplication strictly adds degrees over prime fields $\mathbb{F}_p$.
* **Hacker's Takeaway:** Unchecked degree evolution and unconstrained polynomial signals create soundless verification states and setup overflows.
* **The Fix:** Explicitly constrain every output coefficient in R1CS and enforce cryptographic low-degree checks on all polynomial commitments.

## My Handwritten Notes Below
<img width="857" height="1280" alt="Image 01" src="https://github.com/user-attachments/assets/fa296097-f008-4fba-8ce7-bec255e33eab" />
<img width="805" height="1280" alt="Image 02" src="https://github.com/user-attachments/assets/b0cebd05-bb2b-4888-a2ec-f640ce7f7985" />
<img width="920" height="1280" alt="Image 03" src="https://github.com/user-attachments/assets/83b7f3b1-2b74-404c-91ab-afa487d3412c" />
<img width="847" height="1280" alt="Image 04" src="https://github.com/user-attachments/assets/7854c16e-fb65-46af-9ffe-87c41cdd7fba" />












