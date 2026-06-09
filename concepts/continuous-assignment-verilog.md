---
aliases: ["Continuous Assignment Verilog", "continuous assignment", "assign statement"]
tags: [concept, cs2214, week2]
---

# Continuous Assignment Verilog

The Verilog style that uses `assign` statements to express Boolean expressions directly. More readable than [[Structural Verilog]] for complex logic. The hardware synthesized is identical.

```verilog
assign Y = (~A & ~B & C) | ~D;
```

`~` = NOT, `&` = AND, `|` = OR, `^` = XOR. The `assign` keyword means the output wire is continuously driven by the expression — not a one-time assignment.

**First taught:** [[Week 2 - Verilog & Bitwise Operations]]
**Related:** [[Verilog]], [[Structural Verilog]], [[Boolean Algebra]], [[Bitwise Operations]]
