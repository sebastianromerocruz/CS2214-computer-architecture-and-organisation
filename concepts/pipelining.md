---
aliases: ["Pipelining", "pipeline", "five-stage pipeline"]
tags: [concept, cs2214, stub]
---

# Pipelining

*Stub — taught in Weeks 6–7*

Overlapping the execution of multiple instructions by dividing the datapath into stages (IF → ID → EX → MEM → WB). Increases throughput but creates [[Data Hazards]].

**NES connection:** The 6502 has a 1-cycle instruction prefetch — the minimal seed of pipelining. No hazards because only one instruction overlaps.

**Related:** [[E20 Processor]], [[Data Hazards]], [[Registers]]
