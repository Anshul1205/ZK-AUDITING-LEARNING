# Day 36: Why Traditional Bitwise Hashes (SHA-256, Keccak-256) Are Expensive in ZK Circuits

## 1. The Core Architectural Mismatch
Traditional cryptographic hash functions (SHA-256, Keccak-256) were designed specifically for native 32-bit and 64-bit CPU architectures, relying heavily on low-level bitwise operations:
- Bitwise XOR ($\oplus$)
- Bitwise AND ($\wedge$)
- Bitwise NOT ($\neg$)
- Circular Bit Rotations ($\text{ROTR}^n$) and Shifts ($\text{SHR}^n$)

In standard microprocessors, these instructions execute in $O(1)$ clock cycles directly through binary logic gates.

In Zero-Knowledge circuits (R1CS and Plonkish systems), execution occurs inside a large prime Galois Field:
$$\mathbb{F}_p = \mathbb{Z} / p\mathbb{Z} \quad \text{where } p \approx 2^{254} \text{ (e.g., BN254)}$$

ZK arithmetization engines natively support only field addition ($+$) and field multiplication ($\times$). There are no native boolean logic gates. Every individual bit must be arithmetized using quadratic polynomial constraints:
$$b \cdot (1 - b) = 0 \quad \text{for } b \in \{0, 1\}$$

---

## 2. The Explosion of Bit-Decomposition (`Num2Bits`)
Because finite field elements cannot directly undergo bitwise operations, variables must be decomposed into bit-arrays using the `Num2Bits` pattern before computing boolean logic:

### A. Linear Reconstruction Invariant
The individual decomposed bits must sum back to the original field element:
$$x = \sum_{i=0}^{n-1} 2^i \cdot b_i$$

### B. Booleanity Invariant
Every decomposed wire must be strictly bounded to binary values:
$$b_i \cdot (1 - b_i) = 0 \quad \forall i \in \{0, 1, \dots, n-1\}$$

Cost: Decomposing a single 32-bit word requires exactly 32 non-linear R1CS constraints solely for the boolean checks.

### C. Boolean Operations in Arithmetic Form
- **AND Gate ($a \wedge b$):**
  $$c = a \cdot b \quad (1 \text{ R1CS multiplication constraint})$$
- **XOR Gate ($a \oplus b$):**
  $$c = a + b - 2(a \cdot b) \quad (1 \text{ R1CS multiplication constraint})$$

---

## 3. Quantitative Constraints & Prover Scalability Comparison

| Hash Function | Native Primitive | Non-Linear Step | Approximate R1CS Constraints |
|---|---|---|---|
| **SHA-256** | Bitwise Boolean Gates | Bitwise Choice, Maj, XOR | $\approx 25,000 - 30,000$ per 512-bit block |
| **Keccak-256** | 64-bit Boolean State | Bitwise $\theta, \rho, \pi, \chi, \iota$ | $\approx 140,000 - 150,000$ per permutation |
| **Poseidon** | Field Elements ($\mathbb{F}_p$) | Power Map ($x^5$) | $\approx 200 - 300$ total |

### Algebraic S-Box Efficiency ($x^5$):
Computing $x^5$ requires only 3 multiplications in $\mathbb{F}_p$:
1. $w_1 = x \cdot x = x^2$
2. $w_2 = w_1 \cdot w_1 = x^4$
3. $S(x) = w_2 \cdot x = x^5$

Total: Only 3 R1CS multiplication gates per S-box, yielding an order-of-magnitude reduction ($\approx 100\times$) in circuit size compared to bitwise hashes.

### Prover Complexity Impact:
Prover wall-clock time and memory consumption scale as:
$$\text{Prover Complexity} \propto O(N \log N)$$
where $N$ is the total constraint count rounded to the nearest power of two ($2^k$). Using bitwise hashes pushes domain size $N$ into millions of constraints, triggering severe latency and memory exhaustion on client-side provers.

---

## 4. Circuit Attack Vectors & Exploits

### 1. Underconstrained Bit-Decomposition
- **Vulnerability:** Custom bitwise optimization routines assign bits via unconstrained hints (`<--`) and enforce the linear sum $\sum 2^i b_i = x$, but omit the quadratic boolean assertion $b_i(1 - b_i) = 0$.
- **Exploit:** An adversary supplies non-binary field elements (e.g., $b_0 = 2, b_1 = 0$ for $x = 2$). The linear sum is satisfied, but non-binary values pass into downstream XOR/AND gadgets, corrupting internal state calculations and enabling proof forgery.

### 2. Modulo $p$ Aliasing ($p < 2^{256}$)
- **Vulnerability:** Packing 256 bits into a single scalar field element without verifying that the integer representation is strictly smaller than the scalar field modulus $p$.
- **Exploit:** Because $2^{256} > p$ on BN254, an attacker can input two distinct pre-images whose outputs differ by exactly $p$. Both evaluate to the identical field element modulo $p$, resulting in a trivial hash collision inside the circuit.

### 3. Prover Memory Exhaustion (Client-Side DoS)
- **Vulnerability:** A circuit permits dynamic, unbounded input lengths verified via SHA-256.
- **Exploit:** An adversary supplies an input requiring dozens of 512-bit message blocks. Generating millions of constraints crashes client-side provers (browsers, mobile wallets) via Out-Of-Memory (OOM) errors.

---

## 5. Auditor Defense Checklist
- **Hash Primitive Verification:** Use algebraic hashes (Poseidon, Rescue) for all internal ZK state (Merkle trees, nullifiers, commitments). Reserve SHA-256/Keccak strictly for cross-chain L1 interoperability or external data signatures.
- **Full Booleanity Constraints:** Confirm that every bit-decomposition component enforces $b_i \cdot (1 - b_i) = 0$ across all decomposed wires without exception.
- **Strict Range Bounds:** Ensure all 256-bit bit-arrays packed into a single field element enforce an explicit $\text{val} < p$ assertion.
- **Static Message Length Bounds:** Enforce static upper bounds on the number of hashed blocks to eliminate prover exhaustion vectors.

---

## My Handwritten Notes 
<img width="1111" height="1589" alt="Image 01" src="https://github.com/user-attachments/assets/c7556200-7589-4e2b-89fb-47db2ea55047" />
<img width="1122" height="1599" alt="Image 02" src="https://github.com/user-attachments/assets/733cf7c4-2085-47a8-b602-aff0bc832c18" />
<img width="1115" height="1600" alt="Image 03" src="https://github.com/user-attachments/assets/8a52f2b1-5935-40c1-a27f-5625d64acf2f" />
<img width="1114" height="1600" alt="Image 04" src="https://github.com/user-attachments/assets/8f135f60-de52-4cad-a57e-2d7564194d2a" />









