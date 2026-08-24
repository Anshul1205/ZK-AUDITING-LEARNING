# Day 23: Polynomial Representations & Degree Bounds in $\mathbb{F}_p[X]$

## 1. Overview & Mathematical Core
In Zero-Knowledge Proof systems (SNARKs/STARKs), arithmetic circuits are translated into polynomials over finite fields $\mathbb{F}_p$. Moving between algebraic formulas and geometric data points requires understanding dual polynomial representations, efficient domain conversion dynamics, and degree enforcement rules.

---

## 2. Polynomial Representations & Operations Trade-off

| Representation | Definition | Addition Complexity | Multiplication Complexity | Best Used For |
| :--- | :--- | :--- | :--- | :--- |
| **Coefficient Form** | $P(X) = \sum_{i=0}^d a_i X^i$ | $O(n)$ | $O(n^2)$ (Naive) | Polynomial commitments (KZG), evaluating at challenge $\zeta$. |
| **Evaluation Form** | $\{(x_0, y_0), \dots, (x_{n-1}, y_{n-1})\}$ | $O(n)$ | $O(n)$ (Pointwise) | Fast constraint multiplication across execution trace. |

---

## 3. Conversion Dynamics (FFT vs Lagrange Interpolation)

### A. Forward Evaluation (Coefficients $\to$ Evaluations)
* **General Domain $D$:** Evaluated via Vandermonde matrix multiplication in $O(n^2)$ time.
* **Subgroup Domain $H = \langle \omega \rangle$:** Evaluated via **Number Theoretic Transform (NTT / FFT)** in $O(n \log n)$ time.

### B. Backward Interpolation (Evaluations $\to$ Coefficients)
* **General Domain (Lagrange Interpolation):**
  $$P(X) = \sum_{i=0}^{n-1} y_i \cdot L_i(X) \quad \text{where } L_i(X) = \prod_{j \neq i} \frac{X - x_j}{x_i - x_j}$$
  * *Time Complexity:* $O(n^2)$.
* **Subgroup Domain $H$ (Inverse NTT / iFFT):**
  * Computes the identical unique polynomial in $O(n \log n)$ time.

---

## 4. Fundamental Theorem of Algebra & Schwartz-Zippel Lemma

1. **Root Bound:** A non-zero polynomial $P(X) \in \mathbb{F}_p[X]$ of degree $d$ has at most $d$ roots in $\mathbb{F}_p$.
2. **Uniqueness Theorem:** If two polynomials $A(X), B(X) \in \mathbb{F}_p[X]$ of degree $\le d$ evaluate identically on $d + 1$ distinct points, then $A(X) \equiv B(X)$ everywhere.
3. **Schwartz-Zippel Soundness:** If a dishonest prover commits to a false polynomial $P(X) \neq 0$, the probability that it evaluates to zero at a random verifier challenge $\zeta \in \mathbb{F}_p$ is:
   $$\text{Prob}[P(\zeta) = 0] \le \frac{d}{p} \approx 0$$

---

## 5. Auditor Security Checklist & Attack Vectors

### Attack Vector 1: Lagrange Zero-Divisor Trap
* **Vulnerability:** If evaluation domain points collide ($x_i \equiv x_j \pmod p$ where $i \neq j$), the Lagrange denominator $(x_i - x_j) \equiv 0 \pmod p$.
* **Impact:** Causes an unhandled modular inverse crash / division-by-zero panic in off-chain verifiers or smart contracts.
* **Auditor Check:** Verify that all domain elements are strictly distinct and that $n \mid (p - 1)$ so that a valid primitive $n$-th root of unity $\omega$ exists.

### Attack Vector 2: Degree Extension Attack (Unconstrained Degree Bug)
* **Vulnerability:** If a protocol fails to enforce strict degree bounds on prover-submitted polynomials, a malicious prover can forge:
  $$P'(X) = P(X) + R(X) \cdot Z_H(X)$$

where $R(X)$ is an arbitrary high-degree polynomial and $Z_H(X) = X^n - 1$.
* **Impact:** Since $Z_H(x) = 0$ for all $x \in H$, $P'(x) = P(x)$ across the entire evaluation domain $H$. The circuit constraints pass, but the prover injects malicious evaluations outside $H$.
* **Auditor Check:** Ensure degree bounds are cryptographically bound via KZG trusted setup maximum power ($\text{deg}(P) \le S_{\max}$) or FRI low-degree testing parameters.

## My Handwritten Notes Below

<img width="1127" height="1600" alt="Image 01" src="https://github.com/user-attachments/assets/dd43ea52-9e58-4236-a82e-7df1e2903eca" />
<img width="899" height="1280" alt="Image 02" src="https://github.com/user-attachments/assets/3f3d9b62-0c06-4054-a2c5-0ee4ed077ea6" />
<img width="899" height="1280" alt="Image 03" src="https://github.com/user-attachments/assets/6aad7797-161b-4512-b9c9-153908d0096c" />
<img width="903" height="1280" alt="Image 04" src="https://github.com/user-attachments/assets/ec33f8a4-1616-43c5-a449-03f6ca08f646" />












