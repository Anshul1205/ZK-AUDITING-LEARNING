# Day 39: Point Doubling Formulas, Tangent Slope over $\mathbb{F}_p$ & The 2-Torsion Singularity

## 1. Overview & Theoretical Foundations
Point Doubling ($[2]P = P + P$) is the core algebraic operation powering elliptic curve scalar multiplication algorithms (such as Double-and-Add). On a Short Weierstrass curve defined over a prime field $\mathbb{F}_p$:
$$E: y^2 = x^3 + ax + b \pmod p$$

When adding an affine point $P(x_1, y_1)$ to itself ($P = Q$), the secant line collapses into a **tangent line** skimming the curve at $P$.

---

## 2. Mathematical Derivations

### A. Tangent Slope ($\lambda$) via Implicit Differentiation
Differentiating both sides of the curve equation with respect to $x$:
$$\frac{d}{dx}(y^2) = \frac{d}{dx}(x^3 + ax + b)$$
$$2y \cdot \frac{dy}{dx} = 3x^2 + a$$

Solving for the derivative $\frac{dy}{dx}$, which defines the tangent slope $\lambda$:
$$\lambda \equiv \frac{3x_1^2 + a}{2y_1} \pmod p \implies \lambda \equiv (3x_1^2 + a) \cdot (2y_1)^{-1} \pmod p$$
*Requirement:* The slope is well-defined if and only if $2y_1 \not\equiv 0 \pmod p$.

### B. Target Coordinates $(x_3, y_3)$ via Polynomial Root Multiplicity
The equation of the tangent line is $y = \lambda(x - x_1) + y_1$. Substituting into the cubic curve gives:
$$(\lambda(x - x_1) + y_1)^2 = x^3 + ax + b \implies x^3 - \lambda^2 x^2 + \dots = 0$$

Because the line is tangent at $x_1$, $x_1$ is a **double root** (multiplicity 2). By Vieta's formulas:
$$x_1 + x_1 + x_3 \equiv \lambda^2 \pmod p$$
$$2x_1 + x_3 \equiv \lambda^2 \pmod p \implies x_3 \equiv \lambda^2 - 2x_1 \pmod p$$

Reflecting across the x-axis ($y_3 \equiv -y_R \pmod p$):
$$y_3 \equiv \lambda(x_1 - x_3) - y_1 \pmod p$$

---

## 3. Comparative Arithmetization Cost (R1CS)

| Operation | Non-Linear Multiplications | Total R1CS Cost |
| :--- | :--- | :--- |
| **Point Addition ($P + Q$)** | $\lambda(x_2 - x_1)$, $\lambda^2$, $\lambda(x_1 - x_3)$ | **3 constraints** |
| **Point Doubling ($[2]P$)** | $x_1^2$, $\lambda(2y_1)$, $\lambda^2$, $\lambda(x_1 - x_3)$ | **4 constraints** |

*Note:* Point Doubling requires 1 additional constraint due to the intermediate squaring of the coordinate ($x_1^2$) in the numerator.

---

## 4. The 2-Torsion Singularity Trap ($y_1 = 0$)
Points with $y_1 = 0$ are elements of the 2-torsion subgroup $E[2]$ satisfying:
$$[2]P = \mathcal{O} \iff P = -P \iff y_1 = -y_1 \iff 2y_1 \equiv 0 \pmod p$$

At $y_1 = 0$, the tangent line is purely vertical (parallel to the y-axis), and the denominator $2y_1$ vanishes.

### Security Vulnerabilities:
1. **Proof-Generation Denial of Service (DoS):**
   Circuits enforcing `inv_2y * (2 * y1) === 1` will fail witness generation on order-2 inputs, collapsing to $0 === 1$ and halting proof pipelines permanently.
2. **Unconstrained Witness Injection:**
   If a circuit naively enforces $\lambda \cdot (2y_1) === 3x_1^2 + a$, and curve parameters satisfy $3x_1^2 + a \equiv 0 \pmod p$ when $y_1 = 0$, the constraint degenerates to $\lambda \cdot 0 === 0$. An adversary can inject an arbitrary slope $\lambda_{\text{fake}}$, allowing complete forgery of output coordinates $(x_3, y_3)$.

---

## 5. Auditor Defense Checklist

- [ ] **Denominator Guard:** Strictly verify $2y_1 \not\equiv 0 \pmod p$ before executing affine slope inversion using an `IsZero` gadget.
- [ ] **Infinity Branching:** Route $y_1 = 0$ inputs to an explicit `isInfinity = 1` flag, bypassing affine evaluation.
- [ ] **Quadratic Intermediate Constraints:** Enforce dedicated multiplication gates on non-linear terms (`x1_sq === x1 * x1`). Never leave intermediate powers as raw hints (`<--`).
- [ ] **Full R1CS Triad Binding:** Verify that $\lambda$, $x_3$, and $y_3$ are strictly constrained together in rank-1 form:
  - $\lambda \cdot (2y_1) === 3 \cdot x_{1\_sq} + a$
  - $\lambda \cdot \lambda === x_3 + 2x_1$
  - $\lambda \cdot (x_1 - x_3) === y_3 + y_1$
     
## My Handwritten Notes Below
<img width="1121" height="1600" alt="Image 01" src="https://github.com/user-attachments/assets/afb0155d-5bd4-4699-84a3-07a9ca8ed885" />
<img width="1126" height="1600" alt="Image 02" src="https://github.com/user-attachments/assets/77e31cbe-3768-4f41-826f-644ccbc6e16d" />
<img width="1119" height="1600" alt="Image 03" src="https://github.com/user-attachments/assets/b6bc4359-023a-4f29-934c-9d8676fefe62" />
<img width="1126" height="1600" alt="Image 04" src="https://github.com/user-attachments/assets/2981e8ff-cf55-4170-9e84-4c89df7facf4" />













