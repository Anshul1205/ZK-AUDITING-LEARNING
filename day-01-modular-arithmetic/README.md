# Day 01 of learning ZK Circuit Auditing

I started with my roadmap Stage 1 Point 1.1.1.1: Understanding modular congruence and remainders. I learned these concepts with the 12 hour wall clock analogy and learned the equivalence model concept.

After that, the next concept is formalizing modular congruence and difference divisibility.

After this, the next concept is the Euclidean division algorithm and remainder mechanics, where I learned the Euclidean equation and the rule which says remainder should be less than m and greater than 0.

After this, the next concept is the negative modulo mechanism, which says keep adding the modulus to the negative number until it becomes positive.

The next concept is basic properties of modular congruence like addition, subtraction, and multiplication, which says two equations with the same modulus can add, subtract, or multiply with each other, but CANNOT divide with each other unless the number is coprime to m.

And at last, I learned underflow attack mechanics and circuit validation. While doing a - b, if b is greater than a, instead of returning a negative number, the result underflows to a finite limit p. Missing the range check (a is greater than or equal to b) causes a field underflow exploit in ZK circuits.

Proof of Work: [View my post on X](https://x.com/sarthaktambule1)
<img width="682" height="910" alt="image" src="https://github.com/user-attachments/assets/bce9ebc0-59e1-4424-a1d6-87263104578b" />
<img width="592" height="886" alt="image" src="https://github.com/user-attachments/assets/8bf549f2-05df-4012-8ec8-cdfbc6a854fd" />
<img width="725" height="907" alt="image" src="https://github.com/user-attachments/assets/d89b9cab-ee9e-4206-bb9c-556e9a16e2a4" />


