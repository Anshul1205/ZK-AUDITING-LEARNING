# Day 02: Modular Arithmetic Properties and Security Implications

Today I covered modular arithmetic properties in finite fields, R1CS gate costs, and the critical vulnerability of unconstrained intermediate signals in Circom.

---

## Key Concepts

### 1. Closure and Range Dynamics
- Property: For any elements a and b in field p, (a + b) mod p is also in field p.
- Elements wrap around the modulo ring from 0 to p-1.

### 2. Field Underflow
- Rule: -x mod p = (p - x) mod p.
- Security Vector: Subtraction underflows to a massive number near p if no explicit range check (a >= b) exists.

### 3. Circom R1CS Gate Costs
- Addition (a + b): Free (0 constraints)
- Multiplication (a * b): 1 constraint
- Optimization: a * b + a * c (2 constraints) -> a * (b + c) (1 constraint)

---

## Security Takeaway: Unconstrained Operations

- Vulnerable (<--): Witness assignment only. Generates zero R1CS constraints, allowing provers to pass fake states.
- Secure (<== or ===): Hard constraints enforced in R1CS.

// Dangerous (No constraint)
c <-- a * b;

// Secure (Enforced constraint)
c <== a * b;
## Hand written notes 
<img width="1600" height="1131" alt="image 1" src="https://github.com/user-attachments/assets/3c227c7c-d43f-4f72-ab54-b8c10d122ad5" />
<img width="1600" height="1134" alt="image 2" src="https://github.com/user-attachments/assets/3becb15b-cde7-4efd-916a-62e455ae6318" />
<img width="1042" height="1489" alt="image 3" src="https://github.com/user-attachments/assets/14aec30e-5ce9-4771-9951-3493c2573602" />


