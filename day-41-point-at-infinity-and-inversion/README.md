# Day 41: Point at Infinity ($\mathcal{O}$) and Point Inversion

$$-P = (x, -y \pmod p) = (x, p - y)$$

## 1. Overview & Axiomatic Foundations
On an elliptic curve $E(\mathbb{F}_p)$ defined by the Short Weierstrass equation:
$$y^2 \equiv x^3 + ax + b \pmod p$$
the group structure forms an abelian group whose identity element is the **Point at Infinity** ($\mathcal{O}$).

### Fundamental Group Axioms:
- **Identity Property:** $P + \mathcal{O} = \mathcal{O} + P = P \quad \forall P \in E(\mathbb{F}_p)$
- **Inverse Property:** $P + (-P) = \mathcal{O}$
- **Point Inversion Formula over $\mathbb{F}_p$:**
  $$-P = (x, -y \pmod p) = (x, p - y)$$

---

## 2. The Affine Singularity Problem
In standard affine coordinates $(x, y) \in \mathbb{F}_p \times \mathbb{F}_p$, the point at infinity $\mathcal{O}$ has no numeric representation:
1. **Weierstrass Invalidation:** Substituting $(0, 0)$ as a placeholder fails curve membership because:
   $$0^2 \not\equiv 0^3 + a(0) + b \pmod p \quad (\text{since } b \neq 0 \text{ in BN254, secp256k1})$$
2. **Division-by-Zero Singularity:** When adding a point to its inverse $P + (-P)$:
   $$\lambda = \frac{y_2 - y_1}{x_2 - x_1} \pmod p = \frac{(p - y) - y}{x - x} = \frac{-2y}{0}$$
   In R1CS, enforcing $(x_2 - x_1) \cdot \text{inv} \equiv 1$ collapses to $0 \cdot \text{inv} \equiv 1$, causing an unprovable state and crashing the prover witness generator.

---

## 3. Projective Coordinates Representation
To prevent division exceptions, points can be mapped to 3D Projective space $\mathbb{P}^2(\mathbb{F}_p)$:
$$(x, y) \iff \left(\frac{X}{Z}, \frac{Y}{Z}\right) \quad (Z \neq 0)$$
- **Homogeneous Weierstrass Equation:**
  $$Y^2 Z = X^3 + a X Z^2 + b Z^3 \pmod p$$
- **Projective Address of $\mathcal{O}$:**
  $$\text{Setting } Z = 0 \implies X = 0 \implies \mathcal{O} = (0 : 1 : 0)$$
- **Validity Invariant:** $(X, Y, Z) \neq (0, 0, 0)$ must be enforced to prevent trivial bypasses where $0 = 0$.

---

## 4. Affine Circuit Handling & Safe Denominators
When arithmetizing curves in affine coordinates, points are represented as tuples:
$$P \triangleq (x, y, \text{isInf}) \quad \text{where } \text{isInf} \in \{0, 1\}$$

### Non-Crashing Safe Denominator Gate:
To evaluate secant slope without division-by-zero crashes:
```circom
signal diff_x <== x2 - x1;
signal isColliding <== IsZero()(diff_x);

// If colliding, route denominator to 1 instead of 0 to prevent prover crash
signal safe_denom <== diff_x + isColliding * 1;
signal inv_denom <-- 1 / safe_denom;
inv_denom * safe_denom === 1;
```
## My Handwritten Notes Below
<img width="1126" height="1600" alt="Image 01" src="https://github.com/user-attachments/assets/d8a699d3-7605-4b34-8cb9-d3f7b1424f9e" />
<img width="1062" height="1600" alt="Image 02" src="https://github.com/user-attachments/assets/6030eba0-43ab-4e5c-96f2-be4dbb2f460e" />
<img width="1118" height="1600" alt="Image 03" src="https://github.com/user-attachments/assets/1d3789ee-b28a-4f0a-b2b4-e733c6102953" />
<img width="1128" height="1600" alt="Image 04" src="https://github.com/user-attachments/assets/5b1c52d9-3745-4462-84a9-d2659c21fcdf" />






