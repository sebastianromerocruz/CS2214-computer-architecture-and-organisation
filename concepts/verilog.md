---
aliases: ["Verilog", "HDL", "hardware description language"]
tags: [concept, cs2214, week2]
---

# Verilog

A hardware description language (HDL) for specifying digital circuits. Unlike a program (a sequence of steps), Verilog describes *what components exist and how they're connected* — everything exists simultaneously. Two styles are used in CS2214:

- [[Structural Verilog]] — explicit gate instantiation; reads like a schematic
- [[Continuous Assignment Verilog]] — `assign` statements; reads like Boolean expressions

**Synthesis** takes a Verilog description and produces an actual circuit (netlist). Simulation tests it in software first.

**First taught:** [[Week 2 - Verilog & Bitwise Operations]]
**Related:** [[Logic Gates]], [[Boolean Algebra]], [[Circuit Analysis]], [[Structural Verilog]], [[Continuous Assignment Verilog]], [[Sequential Logic]]
