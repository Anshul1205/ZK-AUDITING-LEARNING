# Day 20: Primitive Roots (Generators) & ZK Evaluation Domains

## 1. Executive Summary
In zero-knowledge proof systems (PLONK, STARKs, Groth16), algebraic execution traces must be converted into polynomials evaluated over structured evaluation domains ($H$). This requires identifying valid **Primitive Roots (Generators $g$)** in finite fields $\mathbb{F}_p^*$. Choosing weak, unverified, or non-generator elements leads to evaluation domain collapse, point collisions, and small subgroup confinement attacks where private witnesses leak or proofs are forged.

---

## 2. Multiplicative Group $\mathbb{F}_p^*$ & Primitive Roots

### Multiplicative Group Structure
For any prime $p$, the non-zero elements form a cyclic multiplicative group of order $p - 1$:
$$\mathbb{F}_p^* = \{1, 2, 3, \dots, p - 1\}, \quad |\mathbb{F}_p^*| = p - 1$$

### Definition of Primitive Root (Generator $g$)
An element $g \in \mathbb{F}_p^*$ is a primitive root (generator) if and only if its multiplicative order is strictly $p - 1$:
$$\text{ord}(g) = p - 1 \iff \langle g \rangle = \{g^1, g^2, \dots, g^{p-1}\} = \mathbb{F}_p^*$$

* **Full Cycle:** $g^k \not\equiv 1 \pmod p$ for all $1 \le k < p - 1$, and $g^{p-1} \equiv 1 \pmod p$.
* **Subgroup Trap:** If an element $a$ has $\text{ord}(a) = d < p - 1$, it cycles prematurely back to $1$ and spans only a tiny subgroup of size $d$.

---

## 3. Counting & Derivation via Euler's Totient $\phi(p - 1)$

### Total Generator Count
The number of primitive roots in $\mathbb{F}_p$ is strictly equal to Euler's totient of the group order:
$$\text{Total Generators} = \phi(p - 1) = (p - 1) \cdot \prod_{q \mid (p - 1)} \left(1 - \frac{1}{q}\right)$$
where $q$ ranges over all distinct prime factors of $p - 1$.

### Generator Derivation Property
If $g$ is a known primitive root of $\mathbb{F}_p$, then $g^k \pmod p$ is also a primitive root if and only if:
$$\gcd(k, p - 1) = 1$$

### Concrete Calculation ($\mathbb{F}_{13}$):
* $p = 13 \implies p - 1 = 12 = 2^2 \cdot 3^1$ (Prime factors: $q_1 = 2, q_2 = 3$).
* $\phi(12) = 12 \cdot \left(1 - \frac{1}{2}\right) \cdot \left(1 - \frac{1}{3}\right) = 12 \cdot \frac{1}{2} \cdot \frac{2}{3} = 4$ Primitive Roots.
* Coprimes to $12$ in range $[1, 11]$: $k \in \{1, 5, 7, 11\}$.
* Derived Primitive Roots using base $g = 2$:
  * $2^1 \equiv 2 \pmod{13}$
  * $2^5 = 32 \equiv 6 \pmod{13}$
  * $2^7 = 128 \equiv 11 \pmod{13}$
  * $2^{11} = 2048 \equiv 7 \pmod{13}$
* Complete Set: $\{2, 6, 7, 11\}$.

---

## 4. Efficient Prime-Factor Exponentiation Test

Testing all $p - 1$ powers is computationally impossible for cryptographic fields ($p \approx 2^{254}$). By Lagrange's Theorem, any sub-order must divide $(p - 1)/q$ for some prime factor $q$.

### The Decision Rule
Given distinct prime factors $\{q_1, q_2, \dots, q_k\}$ of $p - 1$:
$$g \text{ is a Primitive Root} \iff g^{\frac{p-1}{q_i}} \not\equiv 1 \pmod p \quad \forall q_i$$

### Numerical Verification ($\mathbb{F}_{13}$):
* Prime factors of $12$: $q \in \{2, 3\}$. Checkpoints: $\frac{12}{2} = 6$ and $\frac{12}{3} = 4$.
* Candidate $a = 3$:
  $$3^6 = (3^3)^2 = 27^2 \equiv 1^2 \equiv 1 \pmod{13} \quad \text{[FAIL - Not a generator]}$$
* Candidate $g = 2$:
  * $2^6 = 64 \equiv 12 \not\equiv 1 \pmod{13}$
  * $2^4 = 16 \equiv 3 \not\equiv 1 \pmod{13}$
  * $\rightarrow$ Both checkpoints passed $\implies g = 2$ is a verified Primitive Root.

---

## 5. ZK Bridge: Roots of Unity & Evaluation Domain ($H$)

In PLONK and STARKs, circuit execution traces of size $N$ (where $N = 2^k$ and $N \mid (p - 1)$) are evaluated over a multiplicative subgroup $H$.

### Construction Formula:
1. Primitive $N$-th root of unity:
   $$\omega = g^{\frac{p-1}{N}} \pmod p$$
2. Multiplicative Evaluation Domain:
   $$H = \{1, \omega, \omega^2, \omega^3, \dots, \omega^{N-1}\}, \quad \text{where } \omega^N \equiv 1 \pmod p$$
3. Vanishing polynomial on domain $H$:
   $$Z_H(X) = X^N - 1$$

---

## 6. Security Exploit Scenarios & Auditor Checklist

### 1. Small Subgroup Confinement Attack
* **Vulnerability:** If an unverified base element or rogue prover input belongs to a small subgroup $S \subset \mathbb{F}_p^*$ of order $r \ll p - 1$, computations $x^w \pmod p$ map strictly to $r$ elements.
* **Impact:** The secret witness $w$ leaks modulo $r$. Repeating over different small subgroups allows complete private key/witness recovery via Pohlig-Hellman / Chinese Remainder Theorem (CRT).

### 2. Evaluation Domain Collision & Soundness Breakdown
* **Vulnerability:** If domain generator $\omega$ is derived from a non-generator, its order collapses ($d < N$).
* **Impact:** Domain points collide ($|H| < N$). The vanishing polynomial $Z_H(X)$ fails to enforce uniqueness across constraints, allowing provers to forge polynomial divisibility arguments.

### Auditor Checklist:
- [ ] Verify setup scripts validate generators via $g^{(p-1)/q} \not\equiv 1 \pmod p$ for **every** prime factor $q \mid (p - 1)$.
- [ ] Ensure roots of unity assert $\omega^{N/2} \not\equiv 1 \pmod p$ and $\omega^N \equiv 1 \pmod p$.
- [ ] Confirm public inputs and verifier signals enforce strict subgroup membership checks.


## My Handwritten Notes Below

<img width="912" height="1280" alt="Image 01" src="https://github.com/user-attachments/assets/f58f3fae-f9d9-4b6a-8b08-3bd99f2468a0" />
<img width="1600" height="1110" alt="Image 02" src="https://github.com/user-attachments/assets/42b092ad-b273-484f-8442-6e515817af52" />
<img width="1280" height="914" alt="Image 03" src="https://github.com/user-attachments/assets/aec53cca-1499-4965-a45b-d698ccbf5983" />
<img width="940" height="1280" alt="Image 04" src="https://github.com/user-attachments/assets/39668c55-4800-4b42-b49e-0606c568f31a" />














