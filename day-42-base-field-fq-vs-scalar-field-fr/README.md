# Day 42: Differentiating Base Field $\mathbb{F}_q$ vs Scalar Field $\mathbb{F}_r$

## 📌 Overview
In Elliptic Curve Cryptography and Zero-Knowledge circuit design, systems operate over two fundamentally distinct finite fields with different prime moduli:
1. **Base Field ($\mathbb{F}_q$):** The field of definition where curve point coordinates $(x, y)$ live.
2. **Scalar Field ($\mathbb{F}_r$):** The group order field where secret keys, multipliers ($k$), and native circuit wires live.

Confusing or directly casting between these fields creates critical soundness bugs, including field aliasing, silent modulo wrap-around, and proof forgery.

---

## 1. Dual Field Taxonomy & The Modulus Gap

### Field Roles
* **Base Field $\mathbb{F}_q$:** Coordinates satisfy the Weierstrass equation:
  $$y^2 \equiv x^3 + ax + b \pmod q$$
  All affine point additions, chord slopes ($\lambda$), and doublings evaluate strictly modulo $q$.
* **Scalar Field $\mathbb{F}_r$:** Scalar multiplication cycles through subgroup points:
  $$[k]P = \underbrace{P + P + \dots + P}_{k \pmod r \text{ times}}$$
  Since the group is cyclic of prime order $r$, $[r]P = \mathcal{O}$.

### BN254 Parameter Gap
For the BN254 (alt_bn128) curve:
* $q = 21888242871839275222246405745257275088696311157297823662689037894645226208583$
* $r = 21888242871839275222246405745257275088548364400416034343698204186575808495617$
* **Invariant:** $q \neq r$ and $q > r$ (Gap $\Delta = q - r \approx 2^{127}$).

---

## 2. Hasse's Theorem & Point Counting

The number of valid points on an elliptic curve over $\mathbb{F}_q$ (including the point at infinity $\mathcal{O}$) is bounded by **Hasse's Theorem**:
$$|E(\mathbb{F}_q)| = q + 1 - t \quad \text{where } |t| \le 2\sqrt{q}$$

* $t$ is the **trace of Frobenius**.
* The group order factors as $|E(\mathbb{F}_q)| = h \cdot r$.
* For prime-order curves like BN254 ($h = 1$):
  $$r = q + 1 - t \implies q \neq r$$

---

## 3. The Cross-Field Circuit Dilemma

Every ZK-SNARK circuit executes over a native field defined by the proving system:
$$\mathbb{F}_{\text{native}} = \mathbb{F}_r$$

* **Native R1CS Constraints:** Circom wires evaluate linear combinations modulo $r$:
  $$\left(\sum a_i w_i\right) \cdot \left(\sum b_i w_i\right) \equiv \left(\sum c_i w_i\right) \pmod r$$
* **The Conflict:** If a circuit naively evaluates curve membership:
  $$y^2 \equiv x^3 + ax + b \pmod r \centernot\implies y^2 \equiv x^3 + ax + b \pmod q$$
  Evaluating curve coordinates over $\mathbb{F}_r$ completely invalidates geometric curve soundness.

---

## 4. Non-Native (Foreign) Field Emulation

To manipulate coordinates in $\mathbb{F}_q$ without native modulo $r$ truncation:
1. **Radix-$2^b$ BigInt Limb Decomposition:**
   $$x = \sum_{i=0}^{k-1} x_i \cdot 2^{b \cdot i}$$
   For 254-bit numbers with $b = 64$ bits: $k = 4$ limbs (`x[0], x[1], x[2], x[3]`).
2. **Integer-Lifted Modular Reduction:**
   $$a \cdot b = m \cdot q + c$$
   Computed across polynomial limbs over the integers before field reduction.
3. **Mandatory Limb Range Checks:**
   $$\forall i \in [0, k-1]: x_i < 2^b \quad \text{enforced via } \text{Num2Bits}(b)$$

---

## 5. Auditor Attack Vectors & Edge Cases

### Vector 1: Public Input Aliasing Attack ($x$ vs $x + r$)
* **Vulnerability:** A smart contract receives a coordinate $x \in \mathbb{F}_q$ and passes it to the SNARK verifier without verifying $x < r$.
* **Exploit:** An attacker inputs $x^* = x + r < q$. The verifier evaluates $x^* \equiv x \pmod r$ (valid proof), but the smart contract records $x^* \neq x$, enabling **double-spending or nullifier replays**.

### Vector 2: Missing Limb Range Checks (Foreign Field Injection)
* **Vulnerability:** Decomposing coordinates into BigInt limbs without applying `Num2Bits(b)` to each limb.
* **Exploit:** Prover supplies unconstrained limbs ($x_i \ge 2^b$), inflating values to satisfy limb-multiplication equations while injecting malicious coordinates that bypass curve validation.

### Vector 3: Modulus Truncation in Hash-to-Curve
* **Vulnerability:** Discarding upper bits to fit scalar hashes into curve coordinates.
* **Exploit:** Multi-to-one hash collisions allow pre-computing colliding inputs $m_1 \neq m_2$, resulting in signature forgery.

---

## 🛡️ Auditor Defense Checklist
- [x] **Smart Contract Bound:** Enforce `require(input < r, "Public input exceeds scalar modulus")` on all public inputs before verifier invocation.
- [x] **Strict Limb Range Checks:** Constrain every BigInt limb using `Num2Bits(b)`.
- [x] **Canonical Reduction:** Assert that reconstructed values satisfy $X < q$.
- [x] **Subgroup Validation:** For curves with cofactor $h > 1$, assert $[r]P \equiv \mathcal{O}$.

## My Handwritten Notes Below
<img width="1129" height="1600" alt="Image 01" src="https://github.com/user-attachments/assets/ec6337c5-db26-4784-9927-621402c874fe" />
<img width="1077" height="1600" alt="Image 02" src="https://github.com/user-attachments/assets/c2095ec6-d0fc-4f7b-ae5a-c29a237ef8a6" />
<img width="1057" height="1600" alt="Image 03" src="https://github.com/user-attachments/assets/c2e8dfec-9d9f-4129-b11a-fe6d292cd9f6" />
<img width="1078" height="1599" alt="Image 04" src="https://github.com/user-attachments/assets/c7cbe403-8787-4b26-82cf-34c59b903791" />













