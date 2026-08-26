# Day 25: Polynomial Long Division, Vanishing Polynomials & Quotient Exploits

## 1. Overview & Core Concept
In Zero-Knowledge proving systems (Fp[X]), polynomial long division decomposes an execution relationship into a quotient and a remainder:
A(X) = B(X) * Q(X) + R(X)   where deg(R) < deg(B)

In prime fields Fp, polynomial division is executed by canceling leading terms via modular multiplicative inverses (b_m^(-1) = b_m^(p-2) mod p) rather than floating-point or standard integer division.

---

## 2. Vanishing Polynomial Division & Circuit Satisfiability
In SNARKs/PLONK, all gate identities over an evaluation domain H = {1, w, w^2, ..., w^(n-1)} are batched into a master polynomial P(X):
P(X) = H(X) * Z_H(X) + R(X)
where Z_H(X) = X^n - 1 is the vanishing polynomial.

### Invariants:
* Valid Execution Trace: P(X) evaluates to 0 on all points of H <=> R(X) = 0.
* Quotient Degree Bound: deg(H) = deg(P) - deg(Z_H) = 2n - n = n.
* Constraint Violation: Any invalid gate execution produces R(X) != 0.

---

## 3. Circom Modeling Pattern
Circom cannot directly enforce division (/) or modulo (%) inside R1CS constraints. Division must be modeled via the Witness Assignment + R1CS Verification pattern:

1. Witness Generation (Unconstrained Assignment):
   q <-- a / b;
   r <-- a % b;

2. Strict R1CS Constraint Check:
   a === b * q + r;

3. Strict Range Enforcement:
   Enforce r < b using range check sub-circuits.

---

## 4. Auditor's Security Checklist
* [ ] Remainder Zero Enforcement: Verify that vanishing polynomial division strictly asserts R(X) == 0.
* [ ] Quotient Degree Bounds: Verify that the prover cannot supply an arbitrarily high-degree quotient polynomial to bypass evaluation checks.
* [ ] Circuit Constraint Completeness: Ensure every <-- division computation is paired with a locking === constraint and a range check on the remainder.
* [ ] Fiat-Shamir Transcript Integrity: Ensure random evaluation challenge zeta is cryptographically bound to all previous polynomial commitments to prevent predictable root cancellation attacks.

## My Handwritten Notes Below
<img width="1120" height="1600" alt="Image 01" src="https://github.com/user-attachments/assets/ac5a0659-6c59-40be-aa79-07b2362a4713" />
<img width="1052" height="1600" alt="Image 02" src="https://github.com/user-attachments/assets/5a8944c4-3206-42cf-b84a-f7778379833a" />
<img width="1166" height="1600" alt="Image 03" src="https://github.com/user-attachments/assets/bde6cff8-9efd-4d44-8445-62ad0305ace3" />
<img width="1125" height="1600" alt="Image 04" src="https://github.com/user-attachments/assets/f7aa8971-b2e6-4dc1-a514-7cacb133a052" />






