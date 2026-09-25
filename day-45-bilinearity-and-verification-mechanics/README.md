# Day 45: Bilinearity Property & Verification Mechanics

## Overview
Exploration of Bilinear Pairings $e(P, Q)$, Quadratic Multiplication over Commitments, EVM Multi-Pairing Verification Precompile (0x08), and Proof Malleability Vulnerabilities in ZK-SNARK Systems.

---

## 1. The Bilinear Map & Verification Engine

### Bilinearity Axiom & Exponent Movement
A bilinear map is a pairing function between two elliptic curve groups into a multiplicative target field:
$$e: \mathbb{G}_1 \times \mathbb{G}_2 \to \mathbb{G}_T$$

The fundamental bilinearity identity guarantees:
$$\forall a, b \in \mathbb{F}_r, \quad e([a]P, [b]Q) = e(P, Q)^{a \cdot b} = e([ab]P, Q) = e(P, [ab]Q)$$

- Non-Degeneracy: For all non-zero generator points $P \neq \mathcal{O}_{\mathbb{G}_1}$ and $Q \neq \mathcal{O}_{\mathbb{G}_2}$, the pairing never collapses to identity: $e(P, Q) \neq 1_{\mathbb{G}_T}$.
- Bilinear Scalar Shift: The scalars (exponents) can freely cross the pairing boundary, allowing verification of multiplication over committed representations.

### The Quadratic Multiplication Bridge (Groth16 & KZG)
Standard elliptic curve operations are strictly additive. Bilinear pairings provide the cryptographic bridge to execute exactly one multiplicative check over encrypted group elements:
$$e([a]_1, [b]_2) = e([1]_1, [1]_2)^{a \cdot b} = e([a \cdot b]_1, [1]_2)$$

In Groth16 verification, the verifier validates knowledge of witness satisfaction across the entire circuit via the pairing equation:
$$e(A, B) = e(\alpha, \beta) \cdot e(K_{\text{pub}}, \gamma) \cdot e(C, \delta)$$

---

## 2. Multi-Pairing Product Identities & EVM Architecture

### EVM Precompile (0x08 - ecPairing)
The native Ethereum pairing precompile at address `0x08` does not verify two separate sides of an equality. Instead, it takes an arbitrary array of point pairs and checks if their combined multi-pairing product balances to the target identity element:
$$\prod_{i=1}^k e(P_i, Q_i) \stackrel{?}{=} 1_{\mathbb{G}_T}$$

### Balanced Product Invariant
To evaluate Groth16 verification inside the EVM precompile format, the first proof point $A \in \mathbb{G}_1$ is negated using elliptic curve point negation:
$$-(x, y) = (x, -y \pmod q)$$
$$e(-A, B) = e(A, B)^{-1}$$

The equation is transformed into a balanced four-pairing product:
$$e(-A, B) \cdot e(\alpha, \beta) \cdot e(K_{\text{pub}}, \gamma) \cdot e(C, \delta) = 1_{\mathbb{G}_T}$$

### Batching Performance
Evaluating $k$ pairings independently requires $k$ Miller Loops and $k$ Final Exponentiations. Multi-pairing batching computes $k$ Miller Loops together and executes the computationally expensive Final Exponentiation strictly once:
$$\left( \prod_{i=1}^k \text{MillerLoop}(P_i, Q_i) \right)^{\frac{q^{12}-1}{r}} \stackrel{?}{=} 1_{\mathbb{G}_T}$$

---

## 3. Public Input Representation & Verification Mapping

### Public Input Compression
Public inputs $x_1, x_2, \dots, x_l$ are combined into a single public base point $K_{\text{pub}} \in \mathbb{G}_1$ using structured reference string parameters:
$$K_{\text{pub}} = [L_0]_1 + \sum_{i=1}^l x_i [L_i]_1$$

### Public Signal Order & Soundness Rules
- Declaration Sequence: Circom allocates indices sequentially starting from public outputs, followed by public inputs. Any mismatch in array ordering between the circuit and verifier maps values to incorrect polynomials while still satisfying the pairing mathematically.
- Explicit Constraints: Every public input declared in a circuit must have explicit quadratic constraints. Unconstrained public inputs allow a malicious prover to assign arbitrary values without failing verification.

---

## 4. Auditor Attack Vectors & Pairing Security

### Attack Vector 1: Proof Malleability via Bilinear Symmetry
Due to bilinear linearity, an attacker can scale proof points using an arbitrary non-zero scalar $\lambda \in \mathbb{F}_r^* \setminus \{1\}$:
$$A' = [\lambda]A, \quad B' = [\lambda^{-1}]B, \quad C' = C$$

Evaluating the mutated proof:
$$e(A', B') = e([\lambda]A, [\lambda^{-1}]B) = e(A, B)^{\lambda \cdot \lambda^{-1}} = e(A, B)$$
The verification equation passes unconditionally, producing a new valid proof representation for the exact same statement without knowledge of the witness.

### Attack Vector 2: Proof-Hash Tracking Replay Traps
- Vulnerability: Smart contracts tracking proof uniqueness by hashing external curve coordinates $(A, B, C)$ fail to prevent replay attacks due to proof malleability. An attacker mutates $(A, B)$ into $(A', B')$, generating a different byte hash and bypassing duplicate checks.
- Remediation Rule: Replay protection must strictly track deterministic, cryptographically bound public nullifiers generated inside the Circom circuit from the private witness, independent of external proof coordinates.

---

## 5. Auditor Verification Checklist
1. Replay Protection: Ensure uniqueness is tracked via circuit-derived public nullifiers rather than hashes of proof points $(A, B, C)$.
2. Public Signal Alignment: Confirm that the order of public inputs passed into the verifier array matches Circom's R1CS signal declaration order with zero index displacement.
3. Signal Constraints: Verify that all declared public inputs are bound by explicit quadratic constraints (`===`) within the circuit logic.
4. Precompile Return Assertion: Ensure the verifier asserts that the pairing verification execution successfully evaluates to true (1) in memory.

## 6. My Handwritten Notes Below 
<img width="1078" height="1539" alt="Image 01" src="https://github.com/user-attachments/assets/19911922-0a9b-4e8a-b257-1b756d57152a" />
<img width="994" height="1420" alt="Image 02" src="https://github.com/user-attachments/assets/6cba06d8-3f5d-454b-8fff-74cedc65ecb4" />
<img width="1101" height="1573" alt="Image 03" src="https://github.com/user-attachments/assets/4ef920cc-710c-4407-b836-0c7ab1c877d0" />
<img width="1123" height="1600" alt="Image 04" src="https://github.com/user-attachments/assets/8653dece-a3d4-4738-becb-2f0704c9461e" />







