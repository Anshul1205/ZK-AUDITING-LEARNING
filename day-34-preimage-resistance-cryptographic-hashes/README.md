# Day 34: One-Way Property & Pre-image Resistance in Cryptographic Hashes

## 1. Overview & Core Concept
In cryptographic zero-knowledge circuits, a cryptographic hash function $H: \mathcal{M} \to \mathcal{Y}$ must satisfy strict **Pre-image Resistance (One-Way Property)**. Given a public digest $h = H(m)$, it must be computationally infeasible for any probabilistic polynomial-time (PPT) adversary $\mathcal{A}$ to invert the mapping and find any valid witness $m'$ such that:

$$\Pr_{m \leftarrow \mathcal{M}, \, h = H(m)} \left[ \mathcal{A}(h) = m' \text{ such that } H(m') = h \right] \leq \epsilon$$

Unlike public-key trapdoors (e.g., RSA permutations where a secret private exponent $\tau$ allows effortless inversion), cryptographic hashes like Poseidon, MiMC, or Keccak are keyless. They rely on high non-linear algebraic degree, diffusion rounds, and S-boxes to eliminate all mathematical inversion shortcuts for all participants.

---

## 2. Privacy Primitives & Quantitative Security Bounds

### Role in Zero-Knowledge Protocols
* **State Commitments (Hiding):**
  $$\mathcal{C} = H(\text{secret} \parallel \text{nullifierSecret})$$
  Pre-image resistance guarantees that public leaves stored in Merkle trees do not reveal private account data or ownership keys.
* **Spend Nullifiers (Unlinkability & Double-Spend Prevention):**
  $$\mathcal{N} = H(\text{nullifierSecret})$$
  Ensures that spending an asset prevents double-spending on-chain without linking the published nullifier back to the original commitment leaf.
* **Proof of Secret Knowledge:**
  Allows a prover to convince a verifier that they possess private witness $w$ satisfying $H(w) == h$ without exposing $w$.

### Mathematical Work Factor
* For an idealized random oracle mapping to an $n$-bit output space $\{0, 1\}^n$, classical pre-image search has a computational complexity of:
  $$\mathbb{E}[\text{Operations}] \approx 2^n$$
* Over the 254-bit scalar field $\mathbb{F}_p$ of BN254 ($p \approx 2^{254}$):
  $$\text{Security Bound} \approx 2^{254} \text{ field operations}$$

---

## 3. Circuit Attack Vectors & Exploitation Mechanics

### Vector 1: Unconstrained Pre-image Witness
* **The Bug:** Confusing assignment (`<--`) with constraint generation (`===` or `<==`). A circuit computes a hash witness but fails to assert equality against the expected public digest instance.
* **Impact:** The R1CS system generates zero constraints binding the input witness to the instance. Provers can forge valid proofs using arbitrary garbage dummy inputs.

### Vector 2: Truncation Soundness Collapse
* **The Bug:** Developers downcast or mask hash outputs (e.g., $h_{\text{trunc}} = H(m) \pmod{2^k}$ where $k \ll 128$) to save gas or fit into smaller integer types.
* **Impact:** The work factor collapses exponentially from $2^{254}$ to $2^k$. If $k = 32$, an adversary brute-forces a matching pre-image offline in seconds using $2^{32} \approx 4.29 \times 10^9$ operations.

### Vector 3: Low-Entropy Witness Inversion (Missing Blinding Salt)
* **The Bug:** Directly hashing low-entropy data (e.g., account balance $\le 10^6$, user age, or boolean flags) without a cryptographic salt.
* **Impact:** Adversaries do not break the hash math; they evaluate $H(0), H(1), \dots$ off-chain to instantly extract private witness state.

### Vector 4: Reduced-Round Algebraic Inversion
* **The Bug:** Manually truncating or reducing the round count of algebraic hashes (e.g., reducing Poseidon full/partial rounds to reduce R1CS constraint count).
* **Impact:** The algebraic degree of the polynomial system drops drastically, allowing adversaries to use Gröbner basis algorithms to solve for the pre-image algebraically.

---

## 4. Auditor's Pre-image Security Checklist
1. **Strict Equality Enforcement:** Verify that every hash output is bound to its target instance using `<==` or explicit `===` checks.
2. **Mandatory 128-Bit Entropy:** Ensure every private witness hashed in commitments includes a blinding factor ($\text{salt} \ge 128\text{ bits}$).
3. **No Digest Truncation:** Ensure verified hash outputs are never truncated or masked below 128 bits: $\min(\text{Digest Length}, \text{Witness Entropy}) \ge 128$.
4. **Input Range Bounds:** Enforce bit-width range checks (`Num2Bits`) on pre-image inputs to prevent finite field wraparound/aliasing attacks ($x + p$).
5. **Audited Round Constants:** Never permit custom or reduced-round configurations for algebraic hashes.

## My Handwritten Notes Below
<img width="882" height="1419" alt="Image 01" src="https://github.com/user-attachments/assets/3f4f395f-0b72-4f00-bcd4-b671a7c575e9" />
<img width="1105" height="1600" alt="Image 02" src="https://github.com/user-attachments/assets/6e0eb12f-73f0-4e85-bc26-989b7929ada4" />
<img width="1121" height="1600" alt="Image 03" src="https://github.com/user-attachments/assets/201fd4e8-a0b4-426f-8283-778297c4c348" />
<img width="1122" height="1600" alt="Image 04" src="https://github.com/user-attachments/assets/68391aa3-1615-416e-871f-d085dec9e177" />
















