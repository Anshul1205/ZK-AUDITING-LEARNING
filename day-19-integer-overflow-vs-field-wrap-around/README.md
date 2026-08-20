# Day 19: Auditing Danger — Integer Overflow vs. Finite Field Wrap-Around Vulnerabilities in ZK Logic

## 1. Theoretical Foundations: Binary Overflow vs. Field Wrap-Around

In traditional computer systems and the Ethereum Virtual Machine (EVM), integer arithmetic is bound by fixed powers of two:
* **EVM / CPU Integer Overflow:** Operates modulo 2^N (e.g., modulo 2^64 or 2^256). When an operation exceeds 2^N - 1, higher-order bits are truncated automatically.
* **ZK Finite Field Wrap-Around:** In Zero-Knowledge circuits (e.g., BN254 / Alt-bn128), all signals are field elements belonging to F_p, where:
  p = 21888242871839275222246405745257275088548364400416034343698204186575808495617 ≈ 2^254
* **Default Signal Behavior:** Declaring `signal input x;` natively bounds the wire only to the field range [0, p - 1]. The circuit does not truncate at 64-bit or 256-bit boundaries.

---

## 2. The Vulnerability Mechanism: Missing Bit-Length Boundaries

A common vulnerability occurs when developers assume that inputs or intermediate values are small bounded integers (e.g., token balances or split shares) without explicitly constraining their bit length inside the circuit.

### Vulnerability Pattern: Unconstrained Conservation Equality
Consider a payment or token split verification:
total_amount === share_a + share_b

* **Intended Application Logic:** share_a, share_b in [0, 2^64 - 1] and share_a + share_b == total_amount.
* **Field Reality:** The R1CS compiler enforces only a single linear field equation:
  (share_a + share_b - total_amount) == 0 (mod p)
* **Exploit Construction:**
  1. Target total_amount = 100.
  2. Malicious prover injects a 254-bit scalar: share_a = p - 50.
  3. Malicious prover sets: share_b = 150.
  4. Field Arithmetic:
     (p - 50) + 150 = p + 100 == 100 (mod p)
  5. The constraint evaluates to 100 === 100, producing a valid ZK proof for an invalid state that mints unbacked scalar balances.

---

## 3. Defense-in-Depth Remediation

To prevent finite field wrap-around exploits, every signal representing a bounded real-world quantity must be decomposed and range-checked using binary decomposition gadgets.

### The Standard Fix: Num2Bits(N)
1. **Binary Bit Decomposition:** Decompose each input signal into N individual bits: out[i] <-- (in >> i) & 1.
2. **Boolean Constraints:** Enforce out[i] * (out[i] - 1) === 0 for all i in [0, N - 1].
3. **Reconstruction Verification:** Enforce lc === in where lc = sum(out[i] * 2^i).
4. **Sum Bound Invariant:** Ensure the sum of maximum bounded ranges cannot exceed the scalar field modulus p:
   sum(2^N_i) < p.

---

## 4. Auditor Checklist for Wrap-Around Bugs

* Identify all `signal input` and intermediate wires involved in additions (a + b), subtractions (a - b), or multiplications (a * b).
* Verify whether each wire represents a bounded integer (balance, age, timestamp, array index).
* Ensure an explicit Num2Bits(N) or LessThan(N) component is bound to each input signal.
* Verify that multi-input sums do not sum up past the prime modulus p.

## My Handwritten Notes Below
<img width="869" height="1280" alt="image 01" src="https://github.com/user-attachments/assets/9ddb50e9-2f41-4d40-95ab-d9d53dfd3eee" />
<img width="879" height="1280" alt="image 02" src="https://github.com/user-attachments/assets/0986314a-f2eb-4037-b9d0-254ca7e6d88f" />
<img width="895" height="1280" alt="image 03" src="https://github.com/user-attachments/assets/04e00945-f98b-4f9b-aa1b-86d283369e93" />
<img width="904" height="1280" alt="image 04" src="https://github.com/user-attachments/assets/7f618321-8ba3-418c-806d-76134bc76228" />










