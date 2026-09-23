# Day 44: Understanding Elliptic Curve Pairings (e: G1 x G2 -> GT)

## 📌 Overview
Explored the mathematical architecture and circuit verification mechanics of Bilinear Pairings on the BN254 curve ($e: \mathbb{G}_1 \times \mathbb{G}_2 \to \mathbb{G}_T$), Miller loops, final exponentiation, and their role in verifying quadratic constraints in Zero-Knowledge SNARKs (Groth16).

---
## 1. The Bilinear Map & The Three Worlds Architecture

**Bilinear Mapping Definition:**
$$e: \mathbb{G}_1 \times \mathbb{G}_2 \to \mathbb{G}_T$$

$$\forall P \in \mathbb{G}_1, Q \in \mathbb{G}_2, \quad a, b \in \mathbb{F}_r: \quad e([a]P, [b]Q) = e(P, Q)^{a \cdot b}$$

**Non-Degeneracy Property:**
$$P \neq \mathcal{O} \land Q \neq \mathcal{O} \implies e(P, Q) \neq 1$$

**Group Topology (Type-3 Asymmetric Pairings):**
* **G1 Group:** Points $(x, y)$ on $E(\mathbb{F}_q)$, size 64 bytes, prime order $r$ (cofactor $h_1 = 1$).
* **G2 Group:** Points on sextic twist $E'(\mathbb{F}_{q^2})$, size 128 bytes, composite order with cofactor $h_2 > 1$.
* **GT Group:** Target multiplicative subgroup of $r$-th roots of unity in $\mathbb{F}_{q^{12}}$ ($k = 12$). Yeh curve points nahi, field elements hain.

---

## 2. Pairing Engine Mechanics & Quadratic Multiplication
- **Two-Stage Pairing Evaluation:**
  $$e(P, Q) = \text{FinalExp}(\text{MillerLoop}(P, Q))$$
  - **Miller Loop:** Evaluates secant/tangent lines across the bits of the curve parameter using point doubling and addition:
    $$f_{i+1} = f_i^2 \cdot \frac{\ell_{T, T}(Q)}{v_{2T}(Q)}$$
    Yields unprojected element $f \in \mathbb{F}_{q^{12}}^\times$.
  - **Final Exponentiation:** Projects raw output $f$ to canonical target group $\mathbb{G}_T$:
    $$z = f^{\frac{q^{12} - 1}{r}} \in \mu_r \implies z^r = 1$$
- **Quadratic Constraint Verification:**
  Standard elliptic curves only allow linear addition ($[a]G + [b]G = [a+b]G$). Pairings unlock exactly one degree of scalar multiplication over commitments without revealing secrets:
  $$A = [a]G_1, \quad B = [b]G_2, \quad C = [c]G_1$$
  $$e(A, B) = e(C, G_2) \iff e(G_1, G_2)^{a \cdot b} = e(G_1, G_2)^c \iff a \cdot b \equiv c \pmod r$$

---

## 3. Auditor Attack Vectors & Pairing Exploits
- **G2 Subgroup Confinement Attack:**
  Twist curve $E'(\mathbb{F}_{q^2})$ contains cofactor $h_2 > 1$. EVM precompile `0x08` checks curve membership but skips subgroup order checks to save gas. An attacker injecting rogue point $\tilde{Q}$ of small order $d \mid h_2$ confines outputs to a small subgroup orbit, leaking private witness scalars via Pohlig-Hellman reduction.
- **Trivial Identity Collapse:**
  Identity elements evaluate trivially: $e(\mathcal{O}, Q) = 1_{\mathbb{G}_T}$. If verifiers allow unchecked $(0, 0)$ coordinates in calldata, an attacker zeros out pairing products ($1 \cdot 1 = 1$), forging valid proofs without satisfying R1CS constraints.
- **Proof Malleability via Bilinear Symmetry:**
  Due to $e([\lambda]A, [\lambda^{-1}]B) = e(A, B)$, adversaries can randomize proof points without altering the pairing result. Using raw proof bytes as nullifiers leads to double-spend and replay vulnerabilities.

---

## 🔒 Auditor Takeaway & Checklist
- Always enforce strict $\mathbb{G}_2$ prime-order subgroup validation ($[r]Q \equiv \mathcal{O}$) on untrusted points.
- Strictly assert $A \neq (0, 0)$, $B \neq ((0, 0), (0, 0))$, and $C \neq (0, 0)$ in verifier contracts.
- Bind proof replay nullifiers to semantic public inputs, never to raw pairing coordinates.
## My Handwritten Notes Below
<img width="976" height="1389" alt="Image 01" src="https://github.com/user-attachments/assets/28aeff10-8544-48a6-a620-d5cabb565147" />
<img width="1030" height="1463" alt="Image 02" src="https://github.com/user-attachments/assets/ccc683e2-1b76-4017-a99e-258836aca163" />
<img width="1061" height="1515" alt="Image 03" src="https://github.com/user-attachments/assets/1f6372a5-7bcd-41fd-a425-0fcf14cef79c" />
<img width="1123" height="1600" alt="Image 04" src="https://github.com/user-attachments/assets/293a86fc-c023-4bd4-9fe3-a417fcb9519b" />




