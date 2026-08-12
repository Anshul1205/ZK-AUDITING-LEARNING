# Day 05: Linear Modular Congruences & ZK Under-Constrained Bugs

## 📌 What I Learned Today
Today I studied **Linear Modular Congruences** of the form:
$$ax \equiv b \pmod m$$

And most importantly, how this mathematical property can create **dangerous ZK Circuit bugs** if an auditor is not paying attention!

---

## 🧠 Core Math Concepts

### 1. Solvability Condition
The equation $ax \equiv b \pmod m$ does NOT always have a solution.
* It is solvable **ONLY IF** $d = \gcd(a, m)$ divides $b$ ($d \mid b$).
* If $\gcd(a, m)$ does NOT divide $b$, then there are **0 solutions** (impossible equation).

### 2. Multiple Solutions (The Attack Vector)
When $d = \gcd(a, m) > 1$, the equation has **exactly $d$ different solutions** modulo $m$.

* **Real Example:** $6x \equiv 4 \pmod 8$
  * Here $a = 6$, $b = 4$, $m = 8$.
  * $\gcd(6, 8) = 2$.
  * Since $2$ divides $4$, solutions exist!
  * Number of solutions = $d = 2$.
  * Valid answers: $x = 2$ and $x = 6$.
  * Check:
    * $6 \times 2 = 12 \equiv 4 \pmod 8$ (Valid)
    * $6 \times 6 = 36 \equiv 4 \pmod 8$ (Valid)

---

## 🚨 ZK Security Impact: Under-Constrained Vulnerability

In Zero Knowledge Circuits, if the developer assumes $x$ has only 1 unique answer (like $x = 2$), but the math allows multiple valid solutions ($x = 2$ and $x = 6$):

1. **Attacker Action:** The attacker can generate a valid proof using $x = 6$ (a fake or unauthorized witness state).
2. **Circuit Result:** The Circom verification WILL PASS because mathematically $x = 6$ satisfies $6x \equiv 4 \pmod 8$!
3. **Root Cause:** The circuit is **Under-Constrained** (missing boundary checks).
4. **Auditor Fix:** Always check if $\gcd(a, m) > 1$. If yes, add explicit **Range Checks** (e.g., `Num2Bits` or `LessThan`) to force $x$ to be in the single intended valid range!

---

## 💻 Circom Code Proof (Vulnerable Implementation)

Below is the code demonstrating this exact vulnerable pattern:

```circom
pragma circom 2.1.0;

// VULNERABLE: 6*x = 4 + 8*k allows both x = 2 and x = 6!
// Attacker can pass fake witness x = 6 to pass verification.
template VulnerableCongruence() {
    signal input x;
    signal input k; // quotient for mod m reduction
    
    // Constraint: 6x ≡ 4 (mod 8)
    6 * x === 4 + 8 * k;
}

component main = VulnerableCongruence();
```
## My Handwritten notes 
<img width="1066" height="1491" alt="Image 01" src="https://github.com/user-attachments/assets/c6692568-abd0-419d-af9f-1c6452d10fb4" />
<img width="1106" height="1545" alt="Image 02" src="https://github.com/user-attachments/assets/6b90f44f-1673-4d1c-9554-af6a8a893edb" />
<img width="953" height="1335" alt="Image 03" src="https://github.com/user-attachments/assets/f49c3553-602a-4306-a610-a9322a35940d" />
<img width="1143" height="1600" alt="Image 04" src="https://github.com/user-attachments/assets/362cfe34-8edd-455d-9e81-cf82555e7e39" />
