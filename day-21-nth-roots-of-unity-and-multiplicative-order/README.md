# Day 21: Defining n-th Roots of Unity & Multiplicative Order

## 1. Mathematical Foundation
An element $\omega \in \mathbb{F}_p^*$ is defined as an **$n$-th Root of Unity** if:
$$\omega^n \equiv 1 \pmod p$$

### Multiplicative Order
The multiplicative order $\text{ord}_p(\omega)$ is the smallest positive integer $k$ such that:
$$\omega^k \equiv 1 \pmod p$$
For $\omega$ to be a **primitive $n$-th root of unity**, it must satisfy:
$$\text{ord}_p(\omega) = n \iff \omega^k \not\equiv 1 \pmod p \quad \forall \, 1 \le k < n$$

---

## 2. Primitive vs Non-Primitive Roots
- **Primitive Root ($\omega$):** Generates all $n$ distinct points in the evaluation domain $H$.
- **Non-Primitive Root ($\alpha$):** Satisfies $\alpha^n \equiv 1 \pmod p$, but $\text{ord}_p(\alpha) = d < n$ (where $d \mid n$). The state space collapses into a smaller cycle of size $d$.

---

## 3. Divisibility Condition & Field 2-Adicity
- **Existence Requirement:** A primitive $n$-th root exists in $\mathbb{F}_p$ if and only if $n \mid (p - 1)$.
- **2-Adicity ($k$):** For prime fields with $p - 1 = 2^k \cdot T$ (where $T$ is odd), $k$ represents the field's 2-adicity.
- **Maximum Circuit Size:** The largest power-of-2 evaluation domain supported is strictly $N_{\max} = 2^k$ (e.g., BN254 scalar field has $k = 28$, allowing up to $2^{28} \approx 268\text{M}$ constraints).

---

## 4. Cyclic Subgroup Structure ($H = \langle \omega \rangle$)
The domain $H = \{1, \omega, \omega^2, \dots, \omega^{n-1}\}$ provides key algebraic symmetries for Fast Fourier Transforms (FFT):
- **Modular Inverse:** $(\omega^i)^{-1} = \omega^{n-i} \pmod p$
- **Negation Symmetry:** $\omega^{n/2} \equiv -1 \pmod p$ (for even $n$)
- **Zero-Sum Property:** $\sum_{i=0}^{n-1} \omega^i \equiv 0 \pmod p$
- **Vanishing Polynomial:** $Z_H(X) = \prod_{i=0}^{n-1} (X - \omega^i) = X^n - 1$

---

## 5. Security Exploits & ZK Auditor Checklist
- **Domain Mismatch Vulnerability:** If a prover and verifier use mismatched domain sizes or a non-primitive root of order $d < n$, checking $Z_H(X) = X^d - 1$ leaves $(n - d)$ constraint rows completely unconstrained, breaking argument soundness.
- **Subgroup Confinement Bug:** Accepting unverified roots in custom cryptographic routines allows attackers to force computations into small subgroups, leaking secret scalars via cycle analysis.

### Auditor Checklist:
1. Enforce both $\omega^n \equiv 1 \pmod p$ and $\omega^{n/2} \equiv -1 \pmod p$ to guarantee full order $n$.
2. Assert domain size divisibility $n \mid (p - 1)$ and check $n \le 2^k$.
3. Ensure prover, verifier, and CRS parameters use strictly identical domain definitions.

## MY Handwritten Notes Below

<img width="833" height="1280" alt="Image 01" src="https://github.com/user-attachments/assets/4cf62c49-4c7c-4de0-9b26-282fd5e11209" />
<img width="1162" height="1600" alt="Image 02" src="https://github.com/user-attachments/assets/f34ccd0d-e0b5-425f-b614-fe66ad62e4d8" />
<img width="1118" height="1600" alt="Image 03" src="https://github.com/user-attachments/assets/4aafcdca-194b-4f05-8090-2da1ea55fc77" />
<img width="1084" height="1600" alt="Image 04" src="https://github.com/user-attachments/assets/9c0fbf20-ef6a-47f5-9b9d-7990abe8f1ad" />



















