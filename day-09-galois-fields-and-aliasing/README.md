# Day 09: Understanding Galois Fields GF(p) & Aliasing Attacks

## 1. Why Galois Fields GF(p) Require Prime Modulus p
- **Field Requirement:** A Galois Field GF(p) requires every non-zero element $a \neq 0$ to have a multiplicative inverse $a^{-1}$ such that $a \cdot a^{-1} \equiv 1 \pmod p$.
- **Bézout's Identity Proof:** An inverse exists if and only if $\gcd(a, p) = 1$. Since $p$ is prime, $\gcd(a, p) = 1$ is mathematically guaranteed for all non-zero elements.
- **Composite Breakdown ($n = p \cdot q$):** In composite moduli, elements sharing factors with $n$ have no inverses, and zero-divisors exist ($p \cdot q \equiv 0 \pmod n$), breaking field axioms.

## 2. Real-World ZK Standard Prime Fields
- **BN254 Scalar Field ($\mathbb{F}_r$):** Prime order $r \approx 2^{254}$ bits used in Circom, SnarkJS, and Ethereum EVM verifiers.
- **BabyJubjub:** Elliptic curve defined over BN254 scalar field for in-circuit Poseidon hashing and EdDSA signatures.
- **Goldilocks Field:** Fast 64-bit prime field ($p = 2^{64} - 2^{32} + 1$) used in Plonky2 and STARK systems.

## 3. Field Mismatch & Aliasing Attacks
- **Bit-Width Gap:** Circuits execute in scalar field $\mathbb{F}_r$ ($\approx 254$ bits), but Solidity contracts use `uint256` ($256$ bits).
- **Proof Malleability:** Since $X \equiv (X + r) \pmod r$, an attacker can pass $X' = X + r$ to a smart contract verifier. Without an explicit check, the contract evaluates $X' \pmod r = X$ and verifies the proof again for a fake input!
- **Mitigation:** Always enforce strict range checks in contract verifiers: `require(publicInput < r, "Public input exceeds scalar field order");`.

## My Handwritten notes Below

<img width="910" height="1280" alt="Image 01" src="https://github.com/user-attachments/assets/b6748ffe-56de-48cb-8936-bb684ef4fa13" />
<img width="898" height="1280" alt="Image 02" src="https://github.com/user-attachments/assets/9cfdaa7d-5c4b-4000-b32e-d76d52651967" />
<img width="897" height="1280" alt="Image 03" src="https://github.com/user-attachments/assets/534b6120-6b1a-4be5-b96d-672f6cf945cb" />
<img width="832" height="1280" alt="Image 04" src="https://github.com/user-attachments/assets/37b2ebec-4bc1-4e4e-ba36-bdacc46d22ee" />














