# Day 29: Point-Evaluation to Coefficient Representation via Lagrange & IFFT

## 1. Overview & Core Mathematical Formulations

Converting a polynomial between **Point-Evaluation Form** and **Monomial Coefficient Form** is a fundamental bridge in SNARK protocol pipelines.

### Dual Representations of $P(X)$:
1. **Point-Evaluation Form:** 
   $$\{(x_0, y_0), (x_1, y_1), \dots, (x_{N-1}, y_{N-1})\}$$
2. **Monomial Coefficient Form:** 
   $$P(X) = a_0 + a_1 X + a_2 X^2 + \dots + a_{N-1} X^{N-1} = \sum_{k=0}^{N-1} a_k X^k$$

---

## 2. Algebraic Lagrange Expansion & Coefficient Extraction

To extract explicit monomial coefficients $a_k \in \mathbb{F}_p$, each Lagrange basis $L_i(X)$ is expanded into powers of $X$:

$$L_i(X) = \prod_{j \neq i} \frac{X - x_j}{x_i - x_j} = \sum_{k=0}^{N-1} c_{i,k} X^k$$

Scaling each basis by $y_i$ and collecting like powers:

$$P(X) = \sum_{i=0}^{N-1} y_i \cdot L_i(X) = \sum_{k=0}^{N-1} \left( \sum_{i=0}^{N-1} y_i \cdot c_{i,k} \right) X^k$$

### Extracted $k$-th Monomial Coefficient:
$$a_k = \sum_{i=0}^{N-1} y_i \cdot c_{i,k} \pmod p$$

---

## 3. The Vandermonde System & Matrix Inversion

Evaluating a polynomial across $N$ distinct points is equivalent to a linear matrix-vector system:

$$V \cdot \mathbf{a} = \mathbf{y}$$

$$\begin{pmatrix} 1 & x_0 & x_0^2 & \dots & x_0^{N-1} \\ 1 & x_1 & x_1^2 & \dots & x_1^{N-1} \\ \vdots & \vdots & \vdots & \ddots & \vdots \\ 1 & x_{N-1} & x_{N-1}^2 & \dots & x_{N-1}^{N-1} \end{pmatrix} \begin{pmatrix} a_0 \\ a_1 \\ \vdots \\ a_{N-1} \end{pmatrix} = \begin{pmatrix} y_0 \\ y_1 \\ \vdots \\ y_{N-1} \end{pmatrix}$$

### Determinant & Invertibility:
$$\det(V) = \prod_{0 \le j < i < N} (x_i - x_j) \pmod p$$

If all evaluation points $x_i$ are pairwise distinct, $\det(V) \neq 0 \pmod p$, allowing direct extraction via inversion:

$$\mathbf{a} = V^{-1} \cdot \mathbf{y} \pmod p$$

---

## 4. Prover Complexity: Fast Interpolation (IFFT) vs Direct Inversion

| Operation | Point-Evaluation Form | Monomial Coefficient Form | Transformation Method |
|---|---|---|---|
| **Pointwise Gate Arithmetic** | $O(N)$ (Linear) | $O(N^2)$ (Convolution) | - |
| **KZG Commitments & Division** | Infeasible | $O(N)$ commitment / quotient division | - |
| **Point $\to$ Coefficient Conversion** | - | - | **IFFT:** $O(N \log N)$ over Roots of Unity $H$ |
| **Naive Matrix Inversion** | - | - | $O(N^2) \sim O(N^3)$ (Bottleneck) |

---

## 5. Security Exploits & ZK Circuit Audit Checklist

### 1. Vandermonde Singularity via Domain Collision ($x_i = x_j$)
* **Vulnerability:** If public/private inputs allow identical evaluation points without distinctness assertions.
* **Exploit Vector:** If $x_i = x_j$, $\det(V) \equiv 0 \pmod p$. Matrix rank collapses ($\text{rank}(V) < N$), opening a non-trivial null space. Provers can inject forged coefficient vectors $\mathbf{a}_{\text{fake}}$ satisfying all existing wire constraints.

### 2. High-Degree Linear Shift Exploit
* **Vulnerability:** Declaring $N+K$ coefficient signals for only $N$ evaluation point constraints without fixing upper degrees to zero.
* **Exploit Vector:**
  $$P_{\text{exploit}}(X) = P(X) + r \cdot \prod_{i=0}^{N-1} (X - x_i) \pmod p \quad (r \neq 0)$$
  Satisfies $P_{\text{exploit}}(x_i) = y_i$ on all checked domain points while enabling arbitrary polynomial expansion outside the domain.

### 3. Execution Trace Zero-Padding Corruption
* **Vulnerability:** Off-chain provers omitting strict zero-padding when interpolating execution traces of length $M < N$ over domain size $N = 2^k$.
* **Exploit Vector:** Coefficients wrap incorrectly around the domain, altering quotient polynomial divisibility $C(X) / Z_H(X)$ and corrupting state transitions.

---

## 6. Auditor's Verification Rules
1. **Domain Distinctness Assertions:** Enforce $(x_i - x_j) \cdot \text{inv}_{i,j} === 1 \pmod p$ for all $i \neq j$.
2. **Rank & Dimension Soundness:** Ensure the number of linearly independent point constraints strictly matches the number of unconstrained coefficient signals ($M == N$).
3. **Trace Padding Verification:** Enforce explicit zero-padding on all unused indices from $M$ to $N-1$ prior to IFFT evaluation.

## My Handwritten Notes Below
<img width="883" height="1280" alt="Image 01" src="https://github.com/user-attachments/assets/1fd10c7a-b6ae-476e-9ee9-3007788d1efb" />
<img width="1043" height="1600" alt="Image 02" src="https://github.com/user-attachments/assets/4f696315-5ea1-4db1-b5a4-d9bc24259be1" />
<img width="1028" height="1600" alt="Image 03" src="https://github.com/user-attachments/assets/2aeea48e-8fe4-470a-a31b-fc2dd2f399d0" />
<img width="1129" height="1599" alt="Image 04" src="https://github.com/user-attachments/assets/f0cbe12b-8dbe-432a-959b-648f8d982eb1" />











