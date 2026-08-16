# Day 15: Endianness, Serialization Traps & Cross-Domain Aliasing in ZK Circuits

## 1. Overview & Mathematical Context
In Zero-Knowledge proof systems (e.g., Circom over the BN254 curve) and smart contract execution environments (e.g., Ethereum EVM), data serialization boundaries often introduce subtle vulnerabilities due to Endianness mismatches:
- EVM / Solidity ABI Encoding: Operates natively in Big-Endian (BE), where the Most Significant Byte (MSB) is located at index 0.
- Circom & ZK Circuits (Num2Bits, Bits2Num): Operates natively in Little-Endian (LE), where the Least Significant Byte (LSB) or Least Significant Bit is located at index 0.

Failing to properly handle cross-domain serialization leads to silent scalar corruption, payload malleability, and signature bypasses.

---

## 2. Mathematical Packing Mechanics
A 256-bit word consists of 32 bytes:
B = [b_0, b_1, b_2, ..., b_31]

Depending on the serialization mode, the reconstructed scalar value differs:

- Little-Endian (LE) Representation:
  Scalar_LE = sum_{i=0}^{31} (b_i * 256^i)

- Big-Endian (BE) Representation:
  Scalar_BE = sum_{i=0}^{31} (b_i * 256^{31 - i})

Passing an unadjusted Big-Endian byte buffer from Solidity directly into a Little-Endian Circom circuit causes the MSB to receive a weight of 256^31, silently corrupting the expected witness computation.

---

## 3. Circuit Pitfall: Byte-Swapping vs. Bit-Reversal
A common vulnerability in custom Circom templates is confusing Byte-Swapping with Bit-Reversal:

- Byte-Swapping (Correct Endianness Conversion):
  Reverses the order of 32 individual 8-bit bytes (Byte[k] <--> Byte[31 - k]) while preserving the internal 8-bit order inside each byte.
- Bit-Reversal (Destructive Anti-Pattern):
  Reverses all 256 individual bits sequentially (Bit[j] <--> Bit[255 - j]), which corrupts the internal magnitude of every single byte.

---

## 4. Security Impact & Attack Vectors

- Signature Verification Bypass (EdDSA / ECDSA):
  In signature schemes, verification requires computing elliptic curve scalar multiplication: R' = s * G. If the smart contract serializes the scalar s in Big-Endian format while the circuit verifies s assuming Little-Endian (s_LE * G != s_BE * G), an attacker can craft custom signatures with twisted endianness representations to bypass authentication checks.
- Public Input Payload Malleability:
  If public inputs (e.g., transaction hashes, commitments, or state roots) are verified without strict endianness enforcement, an attacker can submit byte-swapped representations (x_attacker = ByteSwap(x_legitimate)) to create duplicate valid proof states or bypass on-chain replay protection mappings.
- Modulo Aliasing & Scalar Overflow:
  Placing high-magnitude Big-Endian bytes into high-order Little-Endian positions (256^31) can push the scalar value beyond the BN254 prime modulus r (x >= r), triggering silent modulo wrap-around and witness corruption.

---

## 5. Auditor Checklist
- [ ] Ensure all 32-byte arrays passed from Solidity contracts to Circom circuits undergo byte-swapping before arithmetic packing.
- [ ] Verify that circuit-level conversion logic flips 8-bit byte blocks, NOT individual bits.
- [ ] Verify that any unpacked 256-bit scalar reconstructed from bytes enforces an explicit x < r boundary check before being used in cryptographic operations.

## My Handwritten Notes Below

<img width="909" height="1280" alt="Image 01" src="https://github.com/user-attachments/assets/1ec468cc-4150-403d-8492-516f3fb61521" />
<img width="926" height="1280" alt="image 02" src="https://github.com/user-attachments/assets/e4ae2649-856c-4d2f-a5ee-3fef34a673f1" />
<img width="908" height="1280" alt="Image 03" src="https://github.com/user-attachments/assets/7c957feb-e228-4040-a0bb-0bedbcdf4593" />
<img width="908" height="1280" alt="Image 04" src="https://github.com/user-attachments/assets/503ea023-b14d-419c-b9af-d09d980a8ca5" />







