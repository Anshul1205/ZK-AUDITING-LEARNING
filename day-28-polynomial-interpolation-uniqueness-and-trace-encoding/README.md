# Day 28: Polynomial Interpolation, Uniqueness & Execution Trace Encoding

## 1. Mathematical Interpolation & The Uniqueness Theorem
* **Lagrange Construction:** Given $n$ distinct evaluation points $(x_0, y_0), (x_1, y_1), \dots, (x_{n-1}, y_{n-1})$ over a finite field $\mathbb{F}_p$, the interpolated polynomial is constructed as:
  $$P(X) = \sum_{i=0}^{n-1} y_i \cdot L_i(X)$$
  where each basis switch is defined as $L_i(X) = \prod_{j \neq i} \frac{X - x_j}{x_i - x_j}$.
* **Strict Degree Bound:** Any set of $n$ points defines a **unique** polynomial of degree $d \leq n-1$.
* **The Uniqueness Property:** If two polynomials $P(X)$ and $Q(X)$ of degree $\leq n-1$ evaluate to the same values across $n$ distinct points, their difference $D(X) = P(X) - Q(X)$ has $n$ roots while having degree $\leq n-1$. By the Fundamental Theorem of Algebra, $D(X) = 0$, meaning $P(X) \equiv Q(X)$.

---

## 2. Execution Trace Encoding in zk-SNARKs / STARKs
* **From Discrete Steps to Continuous Polynomials:** A computation trace vector $w = [w_0, w_1, \dots, w_{n-1}]$ representing step-by-step witness states is mapped over an evaluation domain $H = \{\omega^0, \omega^1, \dots, \omega^{n-1}\} \subset \mathbb{F}_p$ via IFFT/Interpolation:
  $$W(\omega^i) = w_i \quad \forall i \in \{0, 1, \dots, n-1\}$$
* **State Transition Identity:** To verify that state transition $F(w_i, w_{i+1}) = 0$ holds across all steps, the prover establishes divisibility by the domain vanishing polynomial $Z_H(X) = X^n - 1$:
  $$F(W(X), W(\omega \cdot X)) = H(X) \cdot Z_H(X)$$
  where $H(X)$ is the valid quotient polynomial.

---

## 3. Vulnerability Analysis & Security Exploits

### A. Under-Constrained Degree / Witness Ambiguity
* **Attack Mechanism:** If the degree bound $\deg(P) \leq n-1$ is not enforced by the polynomial commitment scheme (e.g., unbounded SRS or unchecked quotient degrees), a malicious prover can construct:
  $$P_{\text{fake}}(X) = P(X) + A(X) \cdot Z_H(X)$$
* **Impact:** For all domain points $\omega^i \in H$, $Z_H(\omega^i) = 0$, causing $P_{\text{fake}}(\omega^i) = P(\omega^i) = w_i$. The proof verifies on domain points while allowing arbitrary fake state injections outside $H$.

### B. Circom Domain Collision & Modular Inversion Bypass
* **Attack Mechanism:** In R1CS interpolation logic, computing $(x_i - x_j)^{-1}$ without enforcing $D \cdot D^{-1} === 1$ allows a prover to supply arbitrary inverse values when duplicate domain points ($x_i = x_j$) trigger division by zero.
* **Impact:** Allows bypassing boundary conditions and forging evaluation outputs.

---

## 4. ZK Security Auditor Checklist
1. **Degree Boundary Enforcement:** Verify that trusted setup parameters (SRS) and commitment schemes strictly enforce maximum degree $\deg(P) \leq n-1$.
2. **Domain Distinctness:** Ensure all interpolation input points are constrained to be pairwise distinct ($x_i \neq x_j$ for all $i \neq j$).
3. **Inversion Constraint Integrity:** Verify that every non-linear modular division in R1CS circuits includes explicit non-zero checks and inverse constraints ($D \cdot D^{-1} === 1$).

## My Handwritten Notes Below

<img width="1019" height="1600" alt="Image 01" src="https://github.com/user-attachments/assets/2919cdee-ea19-4b40-b436-1bd310473b2e" />
<img width="1119" height="1600" alt="Image 02" src="https://github.com/user-attachments/assets/f65b177c-6108-4446-aa2a-ba5823009fbb" />
<img width="1179" height="1600" alt="Image 03" src="https://github.com/user-attachments/assets/a72d20ca-708f-4b2c-a975-171e3f01dc06" />
<img width="1062" height="1600" alt="Image 04" src="https://github.com/user-attachments/assets/ece28a64-cc89-4152-b4f3-3a2fc32bb3cd" />













