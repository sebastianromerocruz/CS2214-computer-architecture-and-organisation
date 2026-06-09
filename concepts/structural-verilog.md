---
aliases: ["Structural Verilog", "structural style"]
tags: [concept, cs2214, week2]
---

# Structural Verilog

The Verilog style that explicitly instantiates named gate primitives and declares every internal wire. Mirrors a circuit schematic directly. More verbose than [[Continuous Assignment Verilog]] but leaves nothing implicit.

```verilog
wire n1, n2;
not g1(n1, A);
and g2(Y, n1, B);
```

**First taught:** [[Week 2 - Verilog & Bitwise Operations]]
**Related:** [[Verilog]], [[Continuous Assignment Verilog]], [[Logic Gates]]
