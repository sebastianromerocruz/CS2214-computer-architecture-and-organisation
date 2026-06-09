---
aliases: ["Bitwise Operations", "bitwise", "masking"]
tags: [concept, cs2214, week2]
---

# Bitwise Operations

Applying [[logic gates]] operations in parallel across every bit of an integer. AND, OR, XOR, NOT applied to N-bit words rather than single bits. The gate-level operations of [[Week 1 - Logic Gates]] scaled up to the word level.

**Common uses:** masking (AND to isolate bits), setting bits (OR), toggling bits (XOR), clearing bits (AND with complement).

**NES connection:** 6502 programmers use `AND #$0F` to mask the low nibble, `ORA #$80` to set the sign bit. Every byte-level operation the 6502 does is bitwise at its core.

**First taught:** [[Week 2 - Verilog & Bitwise Operations]]
**Related:** [[Logic Gates]], [[Verilog]], [[Continuous Assignment Verilog]], [[Binary Numbers]]
