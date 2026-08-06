# Day 06: Abstract Algebra, Group Theory & ZK Bug Analysis

Today I covered the core mathematical foundations of **Group Theory** and how missing algebraic constraints lead to critical security vulnerabilities (proof forgery) in Zero-Knowledge circuits.

---

## 1. Core Concepts Learned

### Axioms of a Group
A Group $(G, \cdot)$ must strictly satisfy 4 algebraic properties:
1. **Closure**: $\forall a, b \in G, a \cdot b \in G$
2. **Associativity**: $(a \cdot b) \cdot c = a \cdot (b \cdot c)$
3. **Identity Element**: $\exists e \in G \text{ s.t. } a \cdot e = a$
   - Additive Identity $= 0$
   - Multiplicative Identity $= 1$
4. **Inverse Element**: $\forall a \in G, \exists a^{-1} \text{ s.t. } a \cdot a^{-1} = e$

### Finite Field Clarification
- In Finite Fields $\mathbb{F}_p$, **standard division does not exist**.
- Instead, division is performed using **Multiplicative Inverses**:
  $$a / b \implies a \cdot b^{-1} \pmod p$$
- Subtraction is performed using **Additive Inverses**:
  $$a - b \implies a + (p - b) \pmod p$$

---

## 2. Security Angle & Bug Vectors

### Vector A: Zero Injection Attack
If a circuit does not constrain zero inputs properly in a multiplication gate, the entire equation can collapse to 0. An attacker can exploit this unconstrained state to force true constraints and forge proofs.

### Vector B: Identity Point Injection in ECC
In Elliptic Curve Cryptography (ECC):
- The **Point at Infinity ($\mathcal{O}$)** acts as the additive identity element ($P + \mathcal{O} = P$).
- Scalar multiplication with $\mathcal{O}$ results in $\mathcal{O}$:
  $$k \cdot \mathcal{O} = \mathcal{O}$$
- If a circuit fails to verify that an input point $P \neq \mathcal{O}$, an attacker can pass $\mathcal{O}$ to bypass key verification checks.

### Vector C: Field Boundary / Range Check Missing
Field elements must strictly remain within the prime field range $[0, p-1]$. Missing range checks can cause overflow/underflow logic bypasses.

---

## 3. Code Example & Proof Concept

### Bad Circuit (Vulnerable to Zero Injection)
```circom
template ZeroInjectionVuln() {
    signal input a;
    signal input b;
    signal output out;

    // VULNERABILITY: If 'a' is controlled as 0, 'out' becomes 0 
    // regardless of 'b', skipping proper constraint check!
    out <== a * b;
}
```
## My Handwritten notes Below 
<img width="1137" height="1573" alt="Image 1" src="https://github.com/user-attachments/assets/8fd1563e-89ec-49be-b224-fe8b9bb140d4" />
<img width="1137" height="1600" alt="Image 2" src="https://github.com/user-attachments/assets/a0ee0400-3eee-4b89-a974-4b299dfe8c2a" />
<img width="1141" height="1591" alt="Image 3" src="https://github.com/user-attachments/assets/7a57aa98-5378-43d1-a545-b7965b19da33" />
