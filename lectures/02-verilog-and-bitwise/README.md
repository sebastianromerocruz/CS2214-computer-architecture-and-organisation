<h2 align=center>Week I (cont.)</h2>

<h1 align=center>Verilog & Bitwise Operations</h1>

---

## Sections

1. [**Hardware Description: Verilog**](#1)
    1. [**Structural Verilog**](#1-1)
    2. [**Continuous Assignment Verilog**](#1-2)
    3. [**Synthesis**](#1-3)
2. [**Bitwise Operations**](#2)

---

Last time we learned to read a circuit diagram and extract a Boolean expression from it—and to go the other direction, building a truth table from an expression. That's circuit *analysis*. Two questions remain. First: how do you actually describe a circuit to a computer so that real hardware can be synthesised from it? Second: our gates operate on individual 0s and 1s, but a real processor operates on integers. How do those gate-level operations map onto the integers we actually compute with?

---

<a id="1"></a>

## Hardware Description: Verilog

Hardware engineers don't design chips by drawing schematics by hand and mailing them to a fabrication plant. They write code—but it's a fundamentally different kind of code than anything you've written before.

A normal program, in C or Python or Java, describes a *sequence of steps that happen over time*: do this, then do that, then loop back. A hardware description does something else entirely: it specifies *what components exist and how they're connected*. There's no "then." Everything in the description exists simultaneously, just as physical gates on a chip all exist at the same time.

**Verilog** is one of the two dominant hardware description languages in industry (the other is VHDL). It looks a lot like C on the surface, which is a trap—the syntax is similar but the mental model is completely different. When you write Verilog, you are not writing a program that runs. You are writing a specification of a circuit that will be built.

We'll use our running example from last lecture—the circuit with expression `Y = ĀB̄C + D̄`—to show both ways of writing Verilog.

---

<a id="1-1"></a>

### Structural Verilog

**Structural** Verilog is the style that most directly mirrors a circuit diagram. Every gate is explicitly instantiated by name, every internal wire is declared, and the connections between them are spelled out one by one. If you can read a schematic, you can write structural Verilog from it mechanically.

The fundamental unit of organisation in Verilog is a **module**: a self-contained component with a defined interface to the outside world. Think of it the way you think of a function in software—something with inputs and outputs whose internals are hidden from its callers—except that in hardware, many modules can be "running" at the same time, and they're always on.

```verilog
module MyCircuit(A, B, C, D, Y);
    input  A, B, C, D;
    output Y;
```

The name after `module` is the module's identifier. The parenthesised list is the **port list**—every signal that crosses the module boundary must appear here. The `input` and `output` declarations specify which direction each signal flows.

<a id="fg-1"></a>

<p align=center>
    <img src="assets/verilog-module.svg">
    </img>
</p>

<p align=center>
    <sub>
        <strong>Figure I</strong>: A module as an opaque boundary—the port list (A, B, C, D in, Y out) is the only thing callers ever see; the gates that implement it are hidden inside.
    </sub>
</p>

Internal wires—signals that exist only inside the module to carry values between gates—must be declared explicitly:

```verilog
    wire W1, W2;
```

Then we instantiate the gates. The syntax is:

```
gate_type  instance_name ( output_port, input_port1, input_port2, ... );
```

The **first** argument is always the output; the rest are inputs in order. Crucially, the order of these instantiation statements doesn't matter—all gates coexist simultaneously in the final circuit, just as they would on a chip.

Because our circuit inverts A, B, and D before feeding them into other gates, we need explicit `not` gate instances for those signals:

```verilog
    not NA (nA, A);            // nA = ~A
    not NB (nB, B);            // nB = ~B
    not ND (nD, D);            // nD = ~D
    and A1 (W1, nA, nB);       // W1 = ~A & ~B
    and A2 (W2, W1,  C);       // W2 = W1 & C  =  ~A & ~B & C
    or  O1 (Y,  W2, nD);       // Y  = W2 | ~D
endmodule
```

Unlike the `assign` style below, gate-level instantiation doesn't allow expressions like `~A` directly in a port list—each inverted signal needs to be a named wire. The `not` instances create those named wires (`nA`, `nB`, `nD`) that carry the inverted values into the downstream gates.

---

<a id="1-2"></a>

### Continuous Assignment Verilog

Structural Verilog is precise, but it's verbose for describing what is often a simple mathematical relationship. For **combinational logic**—circuits whose output depends only on the *current* inputs—there's a more direct style.

It's worth pausing on "combinational," because it marks an important conceptual divide. A combinational circuit is *stateless*: given the same inputs, it always produces the same output, with no memory of what came before. This is the kind of logic we've been studying. The alternative is *sequential* logic—circuits like flip-flops and registers that have internal state, whose output depends on both the current inputs and the history of past inputs. We'll cover sequential circuits later. For now, everything we're building is combinational.

For combinational logic, **continuous assignment** lets us express the function almost directly as a Boolean equation:

```verilog
module MyCircuit(A, B, C, D, Y);
    input  A, B, C, D;
    output Y;

    assign Y = (~A & ~B & C) | ~D;
endmodule
```

The `assign` statement means: *"Y is continuously driven by the value of this expression."* Whenever any input changes, Y immediately re-evaluates—there's no clock, no sequence of steps. The output tracks the inputs at all times (in the ideal model; real gates have small **propagation delays** that matter when you push clock frequencies high).

Both versions of `MyCircuit` describe the same circuit and produce equivalent hardware. The translation from Boolean notation to Verilog operators is direct:

| Boolean | Verilog |
|---------|---------|
| `Ā`     | `~A`    |
| `AB`    | `A & B` |
| `A + B` | `A \| B`|
| `A ⊕ B` | `A ^ B` |

Operator precedence in Verilog follows C: `~` binds tightest, then `&`, then `^`, then `|`. This matches Boolean precedence (NOT > AND > OR), so expressions translate directly—but always parenthesise explicitly anyway. Silent precedence errors are hard to find.

Your module declarations should follow this pattern:

```verilog
module module_name (port1, port2, ...);
    input  /* input ports */;
    output /* output ports */;
    wire   /* internal wires, if any */;

    assign output = /* expression */;
endmodule
```

---

<a id="1-3"></a>

### Synthesis

Writing correct Verilog is your job. Making it efficient is the tool's job.

A **synthesis** tool takes your Verilog description and produces a **netlist**: a lower-level description of the circuit in terms of primitive gates or, for programmable devices, lookup tables. This netlist is what gets sent to a manufacturer or loaded onto an FPGA. You write what the circuit should *do*; synthesis figures out the most efficient way to *build* it.

A popular open-source synthesis framework is **Yosys**:

```
[Verilog source] ──→ [ yosys ] ──→ [gate-level netlist + diagram]
```

Two things are worth knowing about what synthesis does. First, both Verilog styles—structural and continuous assignment—produce equivalent netlists. The two are genuinely interchangeable; the choice between them is a matter of readability, not of what hardware gets built.

Second, synthesis may **optimise** the circuit. It might reorder gates, merge them, or eliminate redundant logic in ways that preserve the truth table while using fewer transistors. This process is called **logic minimisation**. The implication is freeing: don't contort your Verilog trying to write a clever implementation. Write the correct Boolean function clearly, and trust the tool to find an efficient realisation. A correct description that the tool optimises is far better than a hand-optimised description with a bug.

---

<a id="2"></a>

## Bitwise Operations

We've been thinking about gates operating on individual 0s and 1s. But a real program works with integers—32-bit values, 64-bit values, bytes. How do the gate operations we've been studying apply to those?

The answer is **bitwise operations**: applying a Boolean gate independently to each pair of corresponding bits across two integers, with no interaction between positions. There's no carry, no propagation—each bit column is computed entirely on its own, exactly as if it were a separate single-bit gate. The result is that you can apply AND, OR, XOR, and NOT to whole integers in a single CPU instruction.

This is different from arithmetic, where a carry from one bit position affects the next. It's also different from logical operations like `&&` and `||` in C, which treat any nonzero value as a single "true" and return either 0 or 1. Bitwise operations work on the raw bit pattern of a value, position by position, giving you precise control over individual bits.

In C: `&` is bitwise AND, `|` is bitwise OR, `^` is bitwise XOR, `~` is bitwise NOT. Don't confuse these with `&&`, `||`, and `!`.

---

### Bitwise AND (`&`)

For each bit position, the result is 1 if and only if **both** input bits at that position are 1.

**Example: `10 & 6`**

```
  10  →  1 0 1 0
   6  →  0 1 1 0
         ───────
  &      0 0 1 0  →  2
```

`10 & 6 == 2`. The only position where both inputs had a 1 was position 1 (the 2s place).

<a id="fg-2"></a>

<p align=center>
    <img src="assets/bitwise-and.svg">
    </img>
</p>

<p align=center>
    <sub>
        <strong>Figure II</strong>: Bitwise AND as four independent single-bit AND gates, one per column—the same gate from Lecture 01, just applied position by position with no interaction between columns.
    </sub>
</p>

AND is the standard **masking** tool. If you want to isolate specific bits of a value and zero out everything else, AND the value against a pattern—called a **mask**—that has 1s exactly where you want to look and 0s everywhere else. The AND gate passes through the bits under the 1s and zeros out everything else.

> **NES:** The NES controller shifts button state out one bit at a time through address `$4016`—each read puts the next button (A, B, Select, Start, Up, Down, Left, Right) into bit 0. To test just that one button, real game code does `AND #%00000001`, masking away every bit except the one that was just read. This is the exact same masking pattern, applied inside a 60-times-a-second game loop.

---

### Bitwise OR (`|`)

For each bit position, the result is 1 if **either** input bit at that position is 1.

**Example: `10 | 6`**

```
  10  →  1 0 1 0
   6  →  0 1 1 0
         ───────
  |      1 1 1 0  →  14
```

`10 | 6 == 14`. Where AND clears bits, OR **sets** them. OR-ing a value against a mask turns on every bit that is 1 in the mask while leaving all other bits unchanged. This is how you force specific bits on without touching the rest.

<a id="fg-3"></a>

<p align=center>
    <img src="assets/bitwise-or.svg">
    </img>
</p>

<p align=center>
    <sub>
        <strong>Figure III</strong>: Bitwise OR as four independent single-bit OR gates, one per column.
    </sub>
</p>

> **NES:** Every NES sprite has an attribute byte that packs eight flags into one byte—palette index in bits 0–1, priority in bit 5, horizontal/vertical flip in bits 6–7. To cycle a sprite's palette without disturbing the other bits, real code does `ORA #%00000011` then `EOR #%00000011` then `EOR paletteCycleCounter`—net effect `(byte & ~0x03) | newPalette`. This read-modify-write pattern, using AND to clear a field and OR to set it, is how every hardware register in existence gets written.

---

### Bitwise NOT (`~`)

Flips every bit: 0 becomes 1, 1 becomes 0.

**Example: `~6` as a 4-bit unsigned value**

```
   6  →  0 1 1 0
         ───────
  ~      1 0 0 1  →  9
```

There's an important caveat: `~` flips *all* bits in the integer, so the result depends entirely on the bit-width of the type. In C, `int` is typically 32 bits, so `~6` flips all 32 bits—and combined with two's complement, `~x == -(x+1)` for signed integers. `~6` in C is `-7`, not `9`. Keep bit-width in mind whenever you use `~`.

<a id="fg-4"></a>

<p align=center>
    <img src="assets/bitwise-not.svg">
    </img>
</p>

<p align=center>
    <sub>
        <strong>Figure IV</strong>: Bitwise NOT as four independent inverters, one per bit—flip every column and there is nowhere for a "narrower" result to hide, which is why the answer depends entirely on how many bits you started with.
    </sub>
</p>

---

### Practical Applications

These aren't just abstract exercises. Two patterns in particular come up constantly in systems code—in memory allocators, device drivers, hardware register programming, network packet parsing. If you write C close to the hardware, you will write these patterns.

**Is a number odd or even?**

In binary, the least-significant bit (the 2⁰ place, also called the **LSB**) fully determines parity. An odd number always ends in 1; an even number always ends in 0—because "even" means divisible by 2, and the only bit that contributes the factor of 2¹ or higher is not the last one. We test the LSB by masking with `1`:

```c
bool is_odd(int x) {
    return (x & 1) == 1;
}
```

The parentheses around `x & 1` are essential. In C, `==` has *higher* precedence than `&`, so `x & 1 == 1` parses as `x & (1 == 1)`, which reduces to `x & 1`—accidentally correct here, but wrong in general and confusing always. Parenthesise bitwise sub-expressions explicitly.

**Round down to the nearest multiple of four:**

Any multiple of 4 in binary ends in `...00`—its two least-significant bits are always zero, because 4 = 100₂. To force any integer down to the nearest multiple of 4, we need to zero out its two LSBs while leaving everything else intact. The mask we want has 1s everywhere *except* the last two positions. Since 3 = `...000011`, its bitwise complement is `~3 = ...111100`, which is exactly that mask:

```c
int align_to_4(int x) {
    return x & ~3;
}
```

**Verification** (using 6 bits for clarity):

```
align_to_4(10):  001010 & ~(000011)  =  001010 & 111100  =  001000  =   8
align_to_4(20):  010100 & ~(000011)  =  010100 & 111100  =  010100  =  20
```

For 10 (binary `001010`), the two LSBs `10` get zeroed, giving `001000` = 8. For 20 (binary `010100`), the two LSBs are already `00`, so the value is unchanged.

<a id="fg-5"></a>

<p align=center>
    <img src="assets/mask-align4.svg">
    </img>
</p>

<p align=center>
    <sub>
        <strong>Figure V</strong>: <code>align_to_4(10)</code> as a bit-lane AND against the mask <code>~3</code>—wherever the mask has a 0, the output is forced to 0 no matter what <code>x</code> was.
    </sub>
</p>

The general pattern `x & ~(n-1)` aligns `x` down to the nearest multiple of any power-of-two `n`. You will see this in memory allocators, hardware register setup, and cache-line alignment—anywhere a structure needs to start on a boundary that the hardware requires.

---

<sub>**Previous: [Introduction & Logic Gates](/lectures/01-gates)** || **Next: [Sequential Verilog & the E15 Processor](/lectures/03-sequential-verilog-and-e15)**</sub>
