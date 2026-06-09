---
aliases: ["Two's Complement", "two's complement", "twos complement", "signed integers"]
tags: [concept, cs2214, week1]
---

# Two's Complement

The standard encoding for signed integers in hardware. In an N-bit two's complement number, the most significant bit has weight −2ᴺ⁻¹ instead of +2ᴺ⁻¹. This makes addition and subtraction work with the same circuitry for both signed and unsigned numbers.

**To negate:** invert all bits, add 1.
**Range:** −2ᴺ⁻¹ to 2ᴺ⁻¹ − 1 (asymmetric because zero is in the positive half).
**Overflow:** result too large to fit in N bits; carry discarded, value wraps.

**NES connection:** The 6502's ADC and SBC instructions use the carry and overflow flags to signal two's complement overflow — hardware detecting exactly this problem.

**First taught:** [[Week 1 - Logic Gates]]
**Reappears in:** [[Adders]], [[E15 Processor]], [[E20 Processor]]
**Related:** [[Binary Numbers]], [[Hexadecimal]], [[Adders]]
