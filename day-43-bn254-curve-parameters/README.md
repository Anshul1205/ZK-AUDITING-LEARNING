# Day 43: Exploring BN254 (alt_bn128) Parameters, EVM Precompiles & Security Degradation

## 1. Mathematical Anatomy & Field Parameters
BN254 (historically known as `alt_bn128`) is a pairing-friendly Barreto-Naehrig elliptic curve defined over a 254-bit base field $\mathbb{F}_q$.

### Core Curve Equations:
- **Short Weierstrass Model:**
  $$E(\mathbb{F}_q): y^2 = x^3 + 3 \pmod q \quad [a = 0, b = 3]$$
- **BN Polynomial Family Parameter Seed:**
  $$u = 4965661367728957207 = \text{0x44e992b44a690f0f}$$
- **Base Field Modulus ($q$):**
  $$q(u) = 36u^4 + 36u^3 + 24u^2 + 6u + 1 \approx 2^{254}$$
  $$\text{Hex: } \text{0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47}$$
- **Scalar Field Modulus / Subgroup Order ($r$):**
  $$r(u) = 36u^4 + 36u^3 + 18u^2 + 6u + 1 \approx 2^{254}$$
  $$\text{Hex: } \text{0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001}$$
- **Modulus Delta Gap:**
  $$\Delta = q(u) - r(u) = 6u^2 \approx 2^{127}$$
- **Embedding Degree:**
  $$k = 12 \implies e: \mathbb{G}_1 \times \mathbb{G}_2 \to \mathbb{G}_T \subset \mathbb{F}_{q^{12}}^\times$$

---

## 2. EVM Precompiled Contract Architecture
Ethereum hardcodes native C++/Rust/Go client-level execution via EIP-196 and EIP-197 to avoid exorbitant gas costs associated with high-precision curve arithmetic:

| Precompile Address | Name | Operation | Input Size | Output Size | Gas Cost |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `0x06` | `ecAdd` | Point addition on $\mathbb{G}_1$ ($P_1 + P_2$) | 128 Bytes | 64 Bytes | 150 Gas |
| `0x07` | `ecMul` | Scalar multiplication on $\mathbb{G}_1$ ($[s]P_1$) | 96 Bytes | 64 Bytes | 6,000 Gas |
| `0x08` | `ecPairing` | Bilinear pairing identity check $\prod e(P_i, Q_i) \stackrel{?}{=} 1$ | $k \times 192$ Bytes | 32 Bytes | $34,000 \cdot k + 45,000$ Gas |

### Coordinate Encoding Dimensions:
- **$\mathbb{G}_1$ Points:** $(x, y) \in \mathbb{F}_q \times \mathbb{F}_q \implies 32\text{B} + 32\text{B} = 64\text{ Bytes}$
- **$\mathbb{G}_2$ Points:** Twist curve points over $\mathbb{F}_{q^2}$:
  $$x = x_{\text{re}} + x_{\text{im}} \cdot i, \quad y = y_{\text{re}} + y_{\text{im}} \cdot i \implies 4 \times 32\text{B} = 128\text{ Bytes}$$

---

## 3. The Kim-Barbulescu NFS Attack & Security Degradation
- **Original Assumption:** Estimated at 128 bits of symmetric security.
- **The ExTNFS Breakthrough (2016):** Razvan Barbulescu and Taechan Kim proved that the Extended Tower Number Field Sieve (ExTNFS) drastically lowers discrete log complexity in the target extension field $\mathbb{F}_{q^{12}}^\times$.
- **Security Drop:** Actual security degrades to **$\sim 100\text{ bits}$** ($2^{100}$ operations).
- **Architectural Implication:** BN254 is acceptable for short-to-medium term EVM smart contract settlements, but structurally insecure for long-term (>20 years) high-assurance proofs.

---

## 4. BN254 vs BLS12-381 Comparison

| Metric | BN254 (alt_bn128) | BLS12-381 |
| :--- | :--- | :--- |
| **Base Field Prime ($q$)** | $\approx 254\text{ bits}$ (32 Bytes / 1 Word) | $\approx 381\text{ bits}$ (48 Bytes / 2 Words) |
| **Scalar Field Prime ($r$)** | $\approx 254\text{ bits}$ | $\approx 255\text{ bits}$ |
| **Security Frontier** | $\sim 100\text{ bits}$ (NFS Degraded) | $\approx 128\text{ bits}$ (Post-NFS Secure) |
| **EVM Native Precompiles** | Yes (`0x06`, `0x07`, `0x08`) | No ubiquitous L1 precompiles |
| **Primary Ecosystem** | Circom, SnarkJS, Groth16, L2 Rollups | Eth2 Consensus (BLS Signatures), Zcash |

---

## 5. Auditor Attack Vectors & Edge Cases

### Vector 1: Missing $\mathbb{G}_2$ Subgroup Check in Pairing Verifiers
- While $\mathbb{G}_1$ has prime order $r$ ($h_1 = 1$), the twist curve hosting $\mathbb{G}_2$ has a composite group order:
  $$\#E'(\mathbb{F}_{q^2}) = h_2 \cdot r \quad (h_2 > 1)$$
- EVM precompile `0x08` verifies that coordinates satisfy the curve equation, but omits subgroup verification to save gas.
- **Exploit:** An adversary injects a malicious point $\tilde{Q} \notin \mathbb{G}_2$ whose order divides cofactor $h_2$, bypassing pairing constraints and forging proofs.
- **Fix:** Explicitly assert order-$r$ subgroup membership in the verifier contract before invoking precompile `0x08`:
  $$[r]Q \stackrel{?}{=} \mathcal{O}$$

### Vector 2: 256-bit Non-Canonical Field Aliasing ($X \ge q$)
- EVM `uint256` inputs can take values up to $2^{256}-1$, while BN254 base prime $q < 2^{254}$.
- **Exploit:** If a wrapper contract processes input coordinates before passing them to precompiles without range checks, attackers inject $X^* = X + q < 2^{256}$, triggering duplicate states and public input aliasing.
- **Fix:** Enforce strict canonical checks on calldata words:
  $$\text{require}(x < q \land y < q)$$

### Vector 3: Point-at-Infinity ($\mathcal{O}$) Ambiguity
- Precompiles encode the identity element $\mathcal{O}$ as `(0, 0)`.
- However, $(0, 0)$ fails the affine equation ($0^2 \neq 0^3 + 3$). Unhandled identity inputs either cause false contract reverts (DoS) or neutralize pairing products:
  $$e(\mathcal{O}, Q) = 1$$

## My Handwritten Notes Below
<img width="848" height="1280" alt="Image 01" src="https://github.com/user-attachments/assets/304903fa-cf61-4c09-939b-a25145e80ee2" />
<img width="858" height="1280" alt="Image 02" src="https://github.com/user-attachments/assets/82407e91-227d-4a87-a186-5a53be7b5a3f" />
<img width="971" height="1280" alt="Image 03" src="https://github.com/user-attachments/assets/2e8ab8cc-04f1-41fb-af17-3fa1e91ed485" />
<img width="875" height="1280" alt="Image 04" src="https://github.com/user-attachments/assets/c24ded20-5934-4eec-8c21-4062f8ab64d1" />
<img width="788" height="1280" alt="Image 05" src="https://github.com/user-attachments/assets/5bdb1242-2e4e-47fa-a82a-5779fd183645" />







