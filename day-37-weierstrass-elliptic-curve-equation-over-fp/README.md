# Day 37: Weierstrass Elliptic Curve Equation over F_p

## 1. Short Weierstrass Mathematical Definition
The Short Weierstrass elliptic curve $E$ over a finite prime Galois Field $\mathbb{F}_p$ ($p > 3$) is defined by the set of solutions $(x, y) \in \mathbb{F}_p \times \mathbb{F}_p$ satisfying the congruence:
$$y^2 \equiv x^3 + ax + b \pmod p$$
where parameters $a, b \in \mathbb{F}_p$ are fixed constants.

### The Point Set $E(\mathbb{F}_p)$
$$E(\mathbb{F}_p) = \{(x, y) \in \mathbb{F}_p^2 \mid y^2 \equiv x^3 + ax + b \pmod p\} \cup \{\mathcal{O}\}$$
- **Symmetry:** If $(x, y) \in E(\mathbb{F}_p)$, then $(x, p - y) \in E(\mathbb{F}_p)$.
- **Point at Infinity ($\mathcal{O}$):** The additive identity element satisfying $P + \mathcal{O} = P$ and $P + (-P) = \mathcal{O}$.

---

## 2. The Smoothness Invariant & Discriminant Criterion
For an elliptic curve to form a secure cryptographic group, it must be non-singular (no repeated roots in the cubic polynomial $x^3 + ax + b$).

### The Non-Singularity Invariant
$$4a^3 + 27b^2 \not\equiv 0 \pmod p$$

### Singularity Failures
- **Node ($\Delta \equiv 0$, double root):** The curve self-intersects; the group collapses to the multiplicative group $\mathbb{F}_p^*$, allowing sub-exponential Discrete Logarithm attacks.
- **Cusp ($a = 0, b = 0$, triple root):** The equation collapses to $y^2 \equiv x^3$, forming a sharp pinch at $(0, 0)$. The group collapses to the additive group $(\mathbb{F}_p, +)$, enabling $O(1)$ secret extraction via simple modular division.

---

## 3. Cryptographic Trapdoor: ECDLP & ZK Role
Points on $E(\mathbb{F}_p)$ form an additive abelian group under chord-and-tangent arithmetic:
$$P = [k]G = \underbrace{G + G + \dots + G}_{k \text{ times}}$$

- **Forward Direction:** $O(\log k)$ via Double-and-Add algorithms.
- **Reverse Direction (ECDLP):** Given $P$ and $G$, computing scalar $k$ requires $O(\sqrt{r})$ operations via Pollard's rho algorithm.
- **ZK SNARK Commitments:** Powers $[s^i]G_1$ form the core evaluation basis of KZG polynomial commitments and Groth16 proof coordinates $(A, B, C)$.

### Dual-Field Architecture ($p$ vs. $r$)
- **Base Field $\mathbb{F}_p$:** Field containing point coordinates $(x, y) \in \mathbb{F}_p$.
- **Scalar Field $\mathbb{F}_r$:** Field containing multipliers and private scalars $k \in \mathbb{F}_r$, where $r = \#E(\mathbb{F}_p)$ ($p \neq r$).

---

## 4. Circuit Exploits & Attack Vectors

### 1. The Invalid Curve Attack
- **Vulnerability:** Affine point addition formulas rely only on $a$ and $p$:
  $$\lambda = \frac{y_2 - y_1}{x_2 - x_1} \pmod p, \quad x_3 = \lambda^2 - x_1 - x_2 \pmod p, \quad y_3 = \lambda(x_1 - x_3) - y_1 \pmod p$$
  Parameter $b$ is absent from the addition logic. If a circuit computes scalar multiplications without checking $y^2 === x^3 + ax + b$, the arithmetic executes identically on an attacker-chosen curve $E': y^2 = x^3 + ax + b'$.
- **Exploit:** An attacker inputs coordinates $(x', y')$ belonging to a weak curve $E'$ with small group order factors. The computation is trapped in small subgroups, allowing private witness extraction via the Chinese Remainder Theorem (CRT).

### 2. Scalar Field Aliasing & Malleability
- **Vulnerability:** Accepting private scalar witnesses $k$ without enforcing $k < r$.
- **Exploit:** Prover injects $k' = k + r$. The point $[k']G = [k]G$ remains unchanged on the curve, but internal circuit signals differ, enabling nullifier collision and double-spending.

### 3. Identity Point Division-by-Zero
- **Vulnerability:** Failing to explicitly handle the point at infinity $\mathcal{O}$ in affine coordinates.
- **Exploit:** Supplying $P_1 = P_2$ with $y = 0$ or $P_1 = -P_2$ triggers division by zero ($x_2 - x_1 = 0$), causing circuit proof generation to crash or produce unconstrained witness states.

---

## 5. Auditor Defense Checklist
- **On-Curve Constraint:** Every public and private curve coordinate pair $(x, y)$ MUST enforce:
  $$y^2 === x \cdot (x^2 + a) + b \pmod p$$
- **Non-Singularity Verification:** For circuits with dynamic curve parameters $(a, b)$, verify $4a^3 + 27b^2 \not\equiv 0 \pmod p$.
- **Scalar Range Bounds:** Strictly constrain all multiplier scalars $k$ using bit-decomposition to ensure $k < r$.
- **Explicit Infinity Handling:** Use dedicated boolean flags (`isInfinity`) to bypass affine addition formulas when operating on the identity element $\mathcal{O}$.

---

## My Handwritten Notes Below
<img width="1081" height="1600" alt="Image 01" src="https://github.com/user-attachments/assets/202084ea-b5bc-4314-894a-11bb6cf1a518" />
<img width="1121" height="1599" alt="Image 02" src="https://github.com/user-attachments/assets/08be02b8-7a15-4d9c-aac2-eeba09cada8a" />
<img width="1060" height="1600" alt="Image 03" src="https://github.com/user-attachments/assets/0ca8923c-a108-407f-9bce-c756537b041a" />
<img width="1120" height="1600" alt="Image 04" src="https://github.com/user-attachments/assets/54302916-c690-4858-959d-e99224e2155c" />
