# Day 08: Defining Rings, Fields, & Zero-Divisors

## 1. Ring vs Field
- **Ring (R, +, *):** An algebraic structure with Addition and Multiplication. Addition has inverses (negatives), but Multiplication DOES NOT guarantee inverses for all elements. Division is generally NOT possible in a Ring.
- **Field (F, +, *):** A Commutative Ring where EVERY non-zero element $a \neq 0$ has a unique Multiplicative Inverse $a^{-1}$ such that $a \cdot a^{-1} = 1 \pmod p$.
- **Division in Fields:** Division $a / b$ is formally computed as multiplication by inverse: $a \cdot b^{-1} \pmod p$ (requires $b \neq 0$).

## 2. Zero-Divisors Mechanics
- **Definition:** An element $a \neq 0$ is a Zero-Divisor if there exists another non-zero element $b \neq 0$ such that $a \cdot b = 0$.
- **Field Guarantee:** In a Prime Field $\mathbb{F}_p$, Zero-Divisors DO NOT exist! ($a \cdot b = 0 \implies a = 0 \lor b = 0$).
- **Composite Rings:** Zero-Divisors ONLY exist in non-field composite rings $\mathbb{Z}_m$ (where $m$ is composite, like $\mathbb{Z}_6$ where $2 \cdot 3 = 6 \equiv 0 \pmod 6$).

## 3. ZK Auditor Angle & Exploits
- **Constraint Bypass Attack:** In composite rings, an attacker can pass non-zero inputs $X - Y = 2$ and $K = 3 \pmod 6$ to force $(X - Y) \cdot K = 2 \cdot 3 = 0 \pmod 6$. The circuit falsely verifies $0 = 0$ even when $X \neq Y$, breaking Soundness!
- **Mitigation:**
  1. Execute circuit logic strictly over pure Prime Fields ($\mathbb{F}_p$, e.g., BN254 scalar field prime).
  2. Enforce explicit non-zero check $b \neq 0$ before division.
  3. Enforce $\gcd(x, m) = 1$ if operating in composite modular rings.

## Handwritten Notes are below 
<img width="1078" height="1600" alt="Image 01" src="https://github.com/user-attachments/assets/e7c95f23-8f2f-4ba0-8e09-7143e8918ceb" />
<img width="1149" height="1599" alt="Image 02" src="https://github.com/user-attachments/assets/e4121397-86d6-47a1-b712-34e1350354a1" />
<img width="1068" height="1515" alt="Image 03" src="https://github.com/user-attachments/assets/adc9e995-0714-4df7-aa31-6e70576e34b1" />
