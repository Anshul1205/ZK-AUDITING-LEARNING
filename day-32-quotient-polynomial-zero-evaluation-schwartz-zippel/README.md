# Day 32: Computing Quotient Polynomial Q(X) = P(X) / Z_H(X) over Evaluation Domain H

## Overview
Day 32 focuses on the core zero-knowledge identity $P(X) = Q(X) \cdot Z_H(X)$, proving universal zero-evaluation of circuit constraints across an evaluation domain $H$ without revealing witness evaluations[cite: 6, 8]. It analyzes finite field polynomial division, the Schwartz-Zippel verification protocol at challenge $\gamma \notin H$, and security exploits involving rational fraction remainders and unconstrained opening scalars[cite: 6, 8, 10].

---

## 1. The Fundamental Quotient Identity

### Universal Zero-Evaluation
Let $H = \{\omega^0, \omega^1, \dots, \omega^{n-1}\} \subset \mathbb{F}_p$ be the multiplicative evaluation domain of size $n$, with vanishing polynomial $Z_H(X) = X^n - 1$[cite: 8, 10].
A constraint system satisfies validity across all trace rows if and only if the master relation polynomial $P(X)$ vanishes on $H$[cite: 6, 8]:
$$\forall a \in H \implies P(a) = 0$$[cite: 8]

By the Polynomial Factor Theorem, $Z_H(X)$ must divide $P(X)$ cleanly without a remainder[cite: 5, 6, 10]:
$$P(X) = Q(X) \cdot Z_H(X) \pmod p$$[cite: 6]
where $Q(X) \in \mathbb{F}_p[X]$ is the quotient polynomial[cite: 6, 8].

### Degree Formulation
$$\deg(Q) = \deg(P) - \deg(Z_H) = \deg(P) - n$$[cite: 5, 6]
For standard R1CS gate relations where $P(X) \approx w_L(X) \cdot w_R(X) - w_O(X)$, $\deg(P) \approx 2n$[cite: 1, 6], giving:
$$\deg(Q) = 2n - n = n$$[cite: 1, 6]

---

## 2. Step-by-Step Modular Long Division in $\mathbb{F}_p[X]$

Polynomial division over prime fields computes $Q(X)$ and $R(X)$ via modular inverses rather than rational fractions[cite: 4, 6]:
$$P(X) = Q(X) \cdot Z_H(X) + R(X) \pmod p$$[cite: 6]
where $\deg(R) < n$ or $R(X) = 0$[cite: 6].

### Iterative Monomial Elimination
1. Locate leading term $p_d X^d$ of the dividend and $z_n X^n$ of $Z_H(X)$[cite: 6].
2. Compute quotient monomial:
   $$T_k(X) = (p_d \cdot z_n^{-1} \pmod p) \cdot X^{d - n}$$[cite: 6]
3. Subtract scaled divisor:
   $$P^{(k+1)}(X) = P^{(k)}(X) - T_k(X) \cdot Z_H(X) \pmod p$$[cite: 6]
4. Repeat until the degree of the remaining polynomial drops strictly below $n$[cite: 6].
5. Assert exact divisibility:
   $$\forall c_i \in \text{Coefficients}(R(X)) \implies c_i \equiv 0 \pmod p$$

---

## 3. Succinct Verification via Schwartz-Zippel Lemma

Instead of checking all $n$ domain points individually ($O(n)$ complexity), the verifier samples a random challenge $\gamma \in \mathbb{F}_p \setminus H$[cite: 5, 8, 9]:
$$P(\gamma) \stackrel{?}{=} Q(\gamma) \cdot Z_H(\gamma) \pmod p$$[cite: 6]

### Soundness Error Bound
For a cheating prover where $P(X) \neq Q(X) \cdot Z_H(X)$, the difference polynomial $\Delta(X) = P(X) - Q(X) \cdot Z_H(X)$ has degree $D = \deg(P)$[cite: 6, 8]. By the Schwartz-Zippel Lemma:
$$\text{Pr}[\Delta(\gamma) = 0] \le \frac{D}{|\mathbb{F}_p|} \approx \frac{2^{24}}{2^{254}} = 2^{-230} \approx 0$$[cite: 8]

### Domain Exclusion Requirement ($\gamma \notin H$)
Because $Z_H(a) = 0$ for all $a \in H$[cite: 8, 10], sampling $\gamma \in H$ causes $Q(\gamma) \cdot Z_H(\gamma) = 0$, trivializing the check and failing to test execution soundness across the remaining trace rows[cite: 8].

---

## 4. Constraint Modeling: Out-of-Circuit Division vs In-Circuit Check

Direct division is non-linear and unsupported in R1CS ($A \cdot B = C$)[cite: 3, 7]. Verification is structured as:
* **Off-Circuit Computation:** The prover calculates $Q(X) = P(X) / Z_H(X)$ and evaluates $P(\gamma)$, $Q(\gamma)$, and $Z_H(\gamma) = \gamma^n - 1$[cite: 6, 8, 10].
* **In-Circuit Constraint:** The verifier executes a single quadratic multiplication check[cite: 6]:
  $$P_\gamma === Q_\gamma \cdot Z_{H,\gamma}$$

---

## 5. Security Exploits & Attack Vectors

### 1. Remainder Truncation Exploit
* **Vulnerability:** Prover backend computes $Q(X) = \lfloor P(X) / Z_H(X) \rfloor$ and ignores non-zero remainder $R(X)$ without enforcing $R(X) \equiv 0$ across all coefficients[cite: 6].
* **Exploit:** If the challenge $\gamma$ happens to be a root of $R(X)$ ($R(\gamma) = 0$), $P(\gamma) = Q(\gamma) \cdot Z_H(\gamma)$ holds, verifying a completely invalid execution trace[cite: 6].

### 2. Quotient Degree Inflation
* **Vulnerability:** Protocol fails to enforce $\deg(Q) \le \deg(P) - n$ via trusted setup power-of-tau bounds or split quotient verification[cite: 1, 6].
* **Exploit:** Malicious prover injects higher-order terms $A(X) \cdot Z_H(X)$ to cancel constraint errors on unchecked domain boundaries[cite: 2, 8].

### 3. Missing Cryptographic Commitment Binding
* **Vulnerability:** Verifier checks $P_\gamma === Q_\gamma \cdot Z_{H,\gamma}$ on bare input signals without validating KZG opening proofs against commitments $[P]_1$ and $[Q]_1$[cite: 1, 6, 8, 10].
* **Exploit:** Attacker chooses arbitrary unconstrained scalars $Q_\gamma$ and computes $P_\gamma = Q_\gamma \cdot Z_{H,\gamma} \pmod p$, forging proofs for arbitrary state mutations[cite: 6, 10].

---

## 6. Auditor's Security Checklist
- [ ] Ensure the prover explicitly asserts that every coefficient of the long division remainder $R(X)$ is strictly $0 \pmod p$[cite: 6].
- [ ] Verify that the quotient polynomial is bounded strictly by $\deg(Q) \le \deg(P) - n$[cite: 1, 6].
- [ ] Confirm that random challenge $\gamma$ is derived from a strong Fiat-Shamir transcript that hashes all polynomial commitments ($w_L, w_R, w_O, Q$) before sampling[cite: 7, 8].
- [ ] Verify that evaluation scalars $P_\gamma$ and $Q_\gamma$ are cryptographically bound to their elliptic curve commitments via KZG pairing checks[cite: 1, 8].

## My Handwritten Notes Below 
<img width="1129" height="1600" alt="Image 01" src="https://github.com/user-attachments/assets/80753f4d-a8d9-4a03-abed-0fb5039fadcd" />
<img width="1117" height="1600" alt="Image 02" src="https://github.com/user-attachments/assets/e9f1a94b-6f2c-48c1-ab34-a828724e3e7b" />
<img width="1123" height="1600" alt="Image 03" src="https://github.com/user-attachments/assets/6b7fea7e-1892-4b75-99df-4cee62a5d786" />
<img width="1121" height="1599" alt="Image 04" src="https://github.com/user-attachments/assets/ba2275d8-1e9f-4159-8f90-1e1e03a7ef3d" />














