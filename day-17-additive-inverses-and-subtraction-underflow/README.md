# Day 17: Negative Numbers as Additive Inverses & Subtraction Underflow Exploits in Circom

## 1. Prime Field Arithmetic & Additive Inverses
In Zero-Knowledge circuits defined over prime fields F_p (such as the BN254 / Alt-bn128 scalar field with modulus p ≈ 2^254), negative numbers do not natively exist.
- All elements strictly reside in the integer range [0, p - 1].
- Every negative integer -x is uniquely mapped to its Additive Inverse: -x = p - x (mod p).
- Modular subtraction is natively computed as field addition with the additive inverse: a - b = a + (p - b) (mod p).

---

## 2. EVM Two's Complement vs. ZK Field Representation

- EVM Signed Integers (int256): Ring Z_2^256, uses Two's Complement (2^256 - x) with a dedicated MSB Sign Bit. Underflow wraps around modulo 2^256.
- Finite Prime Field (F_p): Field F_p (p < 2^256), uses Additive Inverse (p - x mod p) with NO sign bit (every bit is positive magnitude). Underflow wraps around modulo p to a massive ~254-bit positive scalar.

The EVM-to-Circuit Aliasing Trap:
When Solidity casts a negative int256(-x) to uint256 and passes it to a ZK verifier:
1. Solidity encodes -x as 2^256 - x.
2. Because 2^256 - x > p, omitting require(input < p) causes the verifier to reduce the input modulo p: Input_circuit = (2^256 - x) mod p.
3. This creates unexpected aliasing, state corruptions, and potential replay attacks.

---

## 3. Circom Subtraction Constraint Mechanics

In Circom, subtraction is enforced as a linear equality constraint:
- Witness calculation (Off-circuit): out <-- a - b;
- Linear constraint enforcement (On-circuit): a === out + b;

The Underflow Illusion:
- If a = 5 and b = 12: out = 5 - 12 = -7 = p - 7 (mod p).
- The R1CS engine verifies: 5 === (p - 7) + 12 === p + 5 === 5 (mod p) -> VALID PROOF!
- The constraint a === out + b throws zero errors and does not prevent modular underflow.

---

## 4. Security Vulnerabilities & Exploit Analysis

Vulnerable Pattern: Unconstrained Balance Settlement
- Circuit computes: new_balance <-- current_balance - withdraw_amount;
- Circuit enforces: current_balance === new_balance + withdraw_amount; (VULNERABLE: No inequality/range check)

Exploit Execution Flow:
1. An attacker with current_balance = 50 requests withdraw_amount = 200.
2. new_balance computes to p - 150.
3. The linear constraint 50 === (p - 150) + 200 (mod p) passes seamlessly.
4. The prover receives a valid proof representing a massive 77-digit scalar balance (p - 150), allowing them to drain funds from the protocol.

---

## 5. Auditor Remediation & Secure Architecture

To prevent additive inverse wrap-around exploits, circuits must strictly bound inputs and enforce explicit inequality logic:
- Layer 1: Enforce explicit inequality (withdraw_amount <= current_balance) using LessEqThan(n).
- Layer 2: Apply bit-length bounding on the output signal using Num2Bits(n) to prevent massive 254-bit wrapped scalars from passing as valid balances.

---

## Key Takeaways for Auditors
- No Negative Values: Never assume a subtraction result can be negative inside an R1CS system; it will always evaluate to a positive field scalar.
- Linear Constraint Fallacy: Linear constraints of the form a === b + c are satisfied equally by honest values and underflow wrap-around pairs.
- Mandatory Bounds: Pair all subtraction operations with LessEqThan checks on operands and Num2Bits decompositions on output signals.

## My Handwritten Notes below

<img width="932" height="1280" alt="Image 01" src="https://github.com/user-attachments/assets/9d9bc4c2-112d-44ba-a9f4-7e0cbff65d9a" />
<img width="828" height="1280" alt="Image 02" src="https://github.com/user-attachments/assets/6abfe3f5-ed26-449e-a672-931e42face12" />
<img width="845" height="1280" alt="Image 03" src="https://github.com/user-attachments/assets/78862423-aedf-4366-a9bf-fa003d5ad647" />
<img width="791" height="1280" alt="Image 04" src="https://github.com/user-attachments/assets/0e2e7328-5fbb-427d-9cac-8b46e054e86d" />







