---
aliases: ["Data Hazards", "data hazard", "RAW", "WAW", "WAR", "forwarding", "load-use hazard"]
tags: [concept, cs2214, stub]
---

# Data Hazards

*Stub — taught in Weeks 7–8*

Conflicts in a [[Pipelining|pipeline]] when an instruction needs a value that a prior instruction hasn't finished producing yet. Types: RAW (read-after-write), WAW, WAR. Primary mitigation: forwarding (bypass). Load-use hazard requires one mandatory stall even with full forwarding.

**Related:** [[Pipelining]], [[E20 Processor]], [[Registers]]
