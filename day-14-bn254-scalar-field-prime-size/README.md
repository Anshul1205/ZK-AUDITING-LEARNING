# Day 14: BN254 Scalar Field Prime Size (r) & EVM uint256 Aliasing

##  Overview
Exploration of the **BN254 (alt_bn128)** scalar field prime modulus $r$, 254-bit element representation, bit-packing boundaries in Circom, EVM `uint256` capacity mismatches, and public input aliasing exploits.

---

##  Key Concepts

### 1. BN254 Scalar Field Modulus ($r$)
Circom circuits natively evaluate wire arithmetic and R1CS quadratic constraints modulo the BN254 scalar field prime order:
$$r = 21888242871839275222246405745257275088548364400416034343698204186575808495617$$
$$\text{Hex: } \text{0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001}$$

* Bit width: $2^{253} < r < 2^{254}$
* Canonical element space: strictly $[0, r - 1]$.

---

### 2. 254-Bit Packing: Safe vs. Danger Zone
* **Safe Zone ($n \le 253$):** `Num2Bits(n)` / `Bits2Num(n)` cannot exceed $r$ because $\max = 2^{253} - 1 < r$.
* **Danger Zone ($n = 254$):** Values in $[r, 2^{254} - 1]$ ($\approx 2^{252}$ non-canonical values) exceed $r$ and silently wrap around modulo $r$. Summing arbitrary 254 bits without `< r` bounds creates multi-witness aliasing bugs.

---

### 3. EVM `uint256` vs. Scalar Modulus ($r$) Mismatch
* EVM word size: 256 bits ($\max = 2^{256} - 1 \approx 1.1579 \times 10^{77}$).
* BN254 Scalar Modulus: 254 bits ($r \approx 2.1888 \times 10^{75}$).
* Because $2^{256} - 1 \approx 4 \times r$, any canonical scalar $x$ has up to 4 equivalent representations modulo $r$:
  $$\{x, \, x + r, \, x + 2r, \, x + 3r\} \le 2^{256} - 1$$

---

##  Security Angle & Attack Vectors

### 1. Public Input Aliasing & Double-Spending Exploit
* **Root Cause:** Ethereum pairing precompiles reduce public inputs modulo $r$, while smart contract mappings (`mapping(uint256 => bool)`) check raw `uint256` values.
* **Attack Scenario:**
  1. Attacker spends legitimate nullifier $x$ ($x < r$) to claim tokens.
  2. Attacker submits $x' = x + r$ with the same underlying ZK proof.
  3. The contract checks `nullifierSpent[x + r]` $\rightarrow$ returns `false`.
  4. On-chain verifier computes $(x + r) \pmod r = x$ $\rightarrow$ proof verification succeeds.
  5. Attacker executes an unauthorized double-spend.

---

##  Auditor Checklist & Remediation
1. **Circom Bit-Decomposition:** When packing or decomposing 254-bit numbers (`Num2Bits(254)`), always pair with an explicit range comparison (`LessThan` or `CompConstant`) against $r$.
2. **Solidity Verifier Interface:** Always enforce strict upper-bound validation on all public inputs before passing them to the pairing verifier:
   ```solidity
   uint256 constant R = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
   require(publicInput < R, "Input scalar out of field range");
   ```
## My Handwritten Notes 

<img width="910" height="1280" alt="Image 01" src="https://github.com/user-attachments/assets/349cd291-efab-4ab2-929a-916b2a929421" />
<img width="893" height="1280" alt="Image 02" src="https://github.com/user-attachments/assets/fc195bbd-2f00-4a61-aca7-ea1e3eb940db" />
<img width="894" height="1280" alt="Image 03" src="https://github.com/user-attachments/assets/129a35f7-df4d-403e-9824-bf045bd9bff4" />
<img width="925" height="1280" alt="Image 04" src="https://github.com/user-attachments/assets/aa7a0c17-f9dd-403e-b258-40f5066e338c" />






