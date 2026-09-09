# Day 38: Geometric and Algebraic Formulas for Point Addition (P + Q) on Elliptic Curves

## 1. Geometric Law & Modular Slope
On a Short Weierstrass elliptic curve $E(\mathbb{F}_p): y^2 \equiv x^3 + ax + b \pmod p$, adding two distinct points $P(x_1, y_1)$ and $Q(x_2, y_2)$ where $x_1 \neq x_2$ follows the chord-and-reflection law:
- A straight secant line intersects the cubic curve at a third point $R(x_3, y_R)$.
- Group axioms ($P + Q + R = \mathcal{O}$) dictate that the result is the reflection of $R$ across the line of symmetry (x-axis):
  $$P + Q = -R = (x_3, p - y_R)$$
- Over $\mathbb{F}_p$, the secant slope $\lambda$ requires a modular multiplicative inverse:
  $$\lambda \equiv (y_2 - y_1) \cdot (x_2 - x_1)^{-1} \pmod p$$

---

## 2. Algebraic Derivation of Target Coordinates
Substituting the straight line equation $y = \lambda(x - x_1) + y_1$ into the curve equation gives:
$$(\lambda(x - x_1) + y_1)^2 \equiv x^3 + ax + b \pmod p$$
Expanding and applying Vieta's formulas for cubic root sums ($x_1 + x_2 + x_3 \equiv \lambda^2 \pmod p$):
$$x_3 \equiv \lambda^2 - x_1 - x_2 \pmod p$$
Reflecting the vertical coordinate gives:
$$y_3 \equiv \lambda(x_1 - x_3) - y_1 \pmod p$$

### R1CS Constraint Invariants
In arithmetic circuits, these coordinates must be strictly enforced through multiplication gates:
- $\lambda^2 === x_3 + x_1 + x_2$
- $\lambda \cdot (x_1 - x_3) === y_3 + y_1$

---

## 3. The Vertical Singularity Trap ($x_1 = x_2$)
When $x_1 = x_2$, the denominator $(x_2 - x_1) \equiv 0 \pmod p$. The computation bifurcates into two distinct cases:
1. **Additive Inverses ($y_1 + y_2 \equiv 0 \pmod p$):** The chord is purely vertical, yielding the Point at Infinity:
   $$P + (-P) = \mathcal{O}$$
2. **Point Doubling ($y_1 = y_2 \neq 0$):** The secant line collapses into a tangent line with slope derived from implicit differentiation:
   $$\lambda_{\text{double}} \equiv \frac{3x_1^2 + a}{2y_1} \pmod p$$

---

## 4. Auditor Vectors & Vulnerabilities

### Attack Vector 1: Division-by-Zero Proof Denial of Service (DoS)
- **Flaw:** Circuit naively enforces `invDiffX * (x2 - x1) === 1`.
- **Impact:** If points collide or negate during loop execution, $(x_2 - x_1) = 0$. The constraint $0 \cdot \text{invDiffX} === 1$ becomes permanently unsatisfiable, crashing proof generation and freezing protocol functionality.

### Attack Vector 2: Unconstrained Branch Selector Exploitation
- **Flaw:** The circuit uses a conditional multiplexer bit $b \in \{0, 1\}$ to select between addition and doubling, but leaves $b$ unconstrained or improperly checks $b === \text{IsEqual}(x_1, x_2)$.
- **Impact:** An attacker injects $x_1 = x_2$ while keeping addition active ($b = 0$). With $(x_2 - x_1) = 0$ and $(y_2 - y_1) = 0$, the constraint $\lambda \cdot 0 === 0$ becomes trivially satisfied for any arbitrary $\lambda$, allowing arbitrary target point generation.

---

## 5. Auditor Defense Checklist
- [ ] **Singularity Protection:** Never enforce affine addition without gating against $x_1 = x_2$.
- [ ] **Sound Multiplexing:** Ensure condition flags separating addition and doubling branches are strictly locked via equality gates: $b === \text{IsEqual}(x_1, x_2)$.
- [ ] **Full Coordinate Binding:** Ensure both $x_3$ and $y_3$ are constrained directly to $\lambda$ in R1CS.
- [ ] **Explicit Identity Handling:** Ensure $P + (-P) = \mathcal{O}$ sets an explicit `isInfinity` flag rather than evaluating through affine division.

## My Handwritten Notes Below 
<img width="1121" height="1600" alt="Image 01" src="https://github.com/user-attachments/assets/8b031bed-4fc3-4ac2-9fbe-e7d70571c30a" />
<img width="1126" height="1600" alt="Image 02" src="https://github.com/user-attachments/assets/e1ae77ed-5c10-4f8b-b74b-ea470068e3ce" />
<img width="1117" height="1600" alt="Image 03" src="https://github.com/user-attachments/assets/b0f66910-f973-4fb2-9bac-31505dc3df25" />
<img width="1114" height="1600" alt="Image 04" src="https://github.com/user-attachments/assets/1c68fbe6-f94d-407f-b24f-b498841e31a9" />









