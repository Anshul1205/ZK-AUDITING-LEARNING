# Day 40: Elliptic Curve Scalar Multiplication ($[k]P$), Double-and-Add & Multiplier Soundness

## 1. Overview & Complexity Foundations
Scalar multiplication is the fundamental operation powering public-key derivation, digital signatures, and commitment schemes across Zero-Knowledge systems:
$$[k]P = \underbrace{P + P + \dots + P}_{k \text{ times}}$$

Naive repeated addition scales with linear complexity $O(k)$, which is completely infeasible for cryptographic field sizes ($k \approx 2^{256}$). The **Double-and-Add** algorithm optimizes this to logarithmic complexity $O(\log_2 k)$ by leveraging the binary expansion of $k$:
$$k = \sum_{i=0}^{n-1} b_i \cdot 2^i \quad \text{where } b_i \in \{0, 1\}$$
For a 256-bit scalar, this caps computation at approximately 256 point doublings and 128 point additions.

---

## 2. Algorithm Architectures

### A. MSB-First Traversal (Left-to-Right)
Begins at the most significant bit ($b_{n-1}$):
1. **Initialize:** $R \leftarrow P$ (skipping leading bit $b_{n-1} = 1$).
2. **Loop:** For $i = n-2$ down to $0$:
   - $R \leftarrow [2]R$ (Point Doubling)
   - If $b_i == 1$: $R \leftarrow R + P$ (Point Addition)
3. **Output:** $R = [k]P$.

### B. LSB-First Traversal (Right-to-Left)
Begins at the least significant bit ($b_0$):
1. **Initialize:** $R \leftarrow \mathcal{O}$ (Accumulator), $T \leftarrow P$ (Base Term).
2. **Loop:** For $i = 0$ up to $n-1$:
   - If $b_i == 1$: $R \leftarrow R + T$ (Accumulation)
   - $T \leftarrow [2]T$ (Power Doubling: $[2^{i+1}]P$)
3. **Output:** $R = [k]P$.

---

## 3. Alternative Advanced Implementations

| Algorithm | Additions per Bit | Doublings per Bit | Characteristics | Primary Context |
| :--- | :--- | :--- | :--- | :--- |
| **Double-and-Add** | $\approx 0.5$ | $1$ | Simple conditional steps | General Circom templates |
| **Windowed NAF (wNAF)** | $\approx \frac{1}{w+1}$ | $1$ | Uses signed digits $\{0, \pm 1, \dots\}$ | Off-circuit prover speedups |
| **Montgomery Ladder** | Exactly $1$ | Exactly $1$ | Uniform execution ($R_1 - R_0 = P$) | Constant-time / Side-channel defense |

*Note on Inversion:* Point negation in affine coordinates is practically free: $-(x_1, y_1) = (x_1, p - y_1)$. Hence, point subtraction costs identical constraints to point addition.

---

## 4. ZK Arithmetization & Constraint Model

In R1CS arithmetic circuits, the scalar $k$ must be unpacked and constrained:
1. **Linear Reconstruction:**
   $$\sum_{i=0}^{n-1} b_i \cdot 2^i === k$$
2. **Boolean Constraining:**
   $$b_i \cdot (1 - b_i) === 0 \quad \forall i \in \{0, \dots, n-1\}$$
3. **Conditional Point Multiplexer:**
   $$\text{Coord}_{\text{next}} === b_i \cdot (\text{Coord}_{\text{add}} - \text{Coord}_{\text{skip}}) + \text{Coord}_{\text{skip}}$$

---

## 5. Security Vulnerabilities & Auditor Attack Vectors

### 1. Missing Boolean Bit Check (Arbitrary Field Injection)
If the circuit enforces $\sum b_i 2^i === k$ but omits $b_i(1 - b_i) === 0$, an attacker sets $b_0 = k$ and remaining bits to $0$. The multiplexer evaluates non-binary field elements, yielding arbitrary coordinates that bypass elliptic curve group laws completely.

### 2. Scalar Truncation & Alias / Malleability Attacks
If a 256-bit scalar is unpacked into fewer bits (e.g., $n = 252$) without strict range validation ($k < r$, where $r$ is the subgroup order), provers can supply $k' = k + 2^{252}$ or $k' = k + r$. The circuit outputs the exact same point $[k]P$ for distinct inputs, breaking signature non-malleability and nullifier uniqueness.

### 3. Intermediate Singularities & Proof Denial of Service (DoS)
Standard affine addition fails if $P = Q$ (requires doubling) or $P = -Q$ (yields $\mathcal{O}$). If intermediate steps or dummy balancing paths hit collisions ($R = T$ or $R = -T$), the denominator $(x_2 - x_1)$ vanishes, crashing the prover with an impossible $0 \cdot \text{inv} === 1$ constraint.

---

## 6. Auditor Defense Checklist

- [ ] **Boolean Enforcement:** Ensure every bit signal satisfies `b[i] * (1 - b[i]) === 0`.
- [ ] **Canonical Range Verification:** Ensure the reconstructed scalar satisfies $k < r$ to prevent aliasing modulo the subgroup order.
- [ ] **Affine Identity Isolation:** Never feed dummy coordinates $(0, 0)$ into standard affine addition gadgets; gate the base case using an explicit `isInfinity` flag or MSB-first non-zero initialization.
- [ ] **Collision Protection:** Verify that multiplexers and dummy branches cannot trigger affine addition singularities ($x_1 = x_2$) during scalar traversal.

## My Handwritten Notes Below 
<img width="878" height="1280" alt="Image 01" src="https://github.com/user-attachments/assets/67b7ec0d-43cb-480a-a547-099c09ab288f" />
<img width="857" height="1280" alt="Image 02" src="https://github.com/user-attachments/assets/15ad02dc-6988-4305-9ce3-fff3dbb6de5e" />
<img width="859" height="1280" alt="Image 03" src="https://github.com/user-attachments/assets/f172219b-b1af-4671-8737-5e437488dc85" />
<img width="866" height="1280" alt="Image 04" src="https://github.com/user-attachments/assets/a7774cdb-8467-44c0-a20d-3ecb04f8bd12" />












