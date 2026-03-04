<h2 align=center>Week I</h2>

<h1 align=center>Introduction & Logic Gates</h1>

---

## Sections

1. [**How Does A Computer Work?**](#1)
2. [**Levels of Abstraction**](#2)
3. [**Gates, Transistors, Semiconductors, Silicon**](#3)
4. [**Logic Gates**](#4)
    1. [**The NOT Gate**](#4-1)
    2. [**The AND Gate**](#4-2)
    3. [**The OR Gate**](#4-3)
    4. [**XOR, NAND, and NOR**](#4-4)
5. [**Boolean Algebraic Notation**](#5)
6. [**Circuit Analysis: Deriving Expressions and Truth Tables**](#6)
7. [**Hardware Description: Verilog**](#7)
    1. [**Structural Verilog**](#7-1)
    2. [**Continuous Assignment Verilog**](#7-2)
    3. [**Synthesis**](#7-3)
8. [**Representing Numbers in Binary**](#8)
9. [**Bitwise Operations**](#9)
10. [**Hexadecimal**](#10)
11. [**Two's Complement**](#11)

---

<a id="1"></a>

## How Does A Computer Work?

This is the question at the heart of what we'll be doing all semester. Before we dig into the technical answer, it's worth sitting with the intuitive one for a moment.

Ask someone off the street and you'll hear things like "electricity," "there's a chip in there," or "depends if you have a Windows or a Google." All of these are, in their own way, pointing at something real—but none of them explain the *mechanism*. Our goal is to build a complete picture, from the physics of electrons all the way up to the software you interact with every day.

The way a computer program gets made and run can be summarized by the following chain:

1. A programmer writes **application software**—a program in a high-level language like C or Python.
2. A **compiler** translates that source code into **assembly language**, a human-readable (barely) representation of the machine's native instruction set.
3. An **assembler** translates assembly into **machine language**—raw binary, the actual bytes your processor reads.
4. The **processor** executes those bytes, manipulating electricity through billions of microscopic switches to produce a result.

The jump from source code to a blinking terminal cursor printing "Hello world" crosses several very different layers of reality. Each layer speaks a completely different language than the one above it, and yet they compose seamlessly. The name for this idea—the organizing principle that makes the whole stack possible—is **abstraction**.

---

<a id="2"></a>

## Levels of Abstraction

**Abstraction** is the practice of hiding complexity behind a clean interface so you can think at a higher level without worrying about the details below. Each layer in the stack trusts that the layer beneath it works correctly, and exposes a simplified interface to the layer above. You used this principle implicitly in section 1: the programmer in that chain doesn't need to know anything about transistors, and the transistors don't need to know anything about Python. Each layer minds its own contract.

The figure below names each layer, from physics at the bottom to user-facing software at the top:

```
┌──────────────────────┬───────────────────────────────────┐
│  Application Software│  Programs                         │
├──────────────────────┼───────────────────────────────────┤
│  Operating Systems   │  Device Drivers                   │
├──────────────────────┼───────────────────────────────────┤
│  Architecture        │  Instructions, Registers          │
├──────────────────────┼───────────────────────────────────┤
│  Microarchitecture   │  Datapaths, Controllers           │
├──────────────────────┼───────────────────────────────────┤
│  Logic               │  Adders, Memories                 │
├──────────────────────┼───────────────────────────────────┤
│  Digital Circuits    │  AND Gates, NOT Gates             │
├──────────────────────┼───────────────────────────────────┤
│  Analog Circuits     │  Amplifiers, Filters              │
├──────────────────────┼───────────────────────────────────┤
│  Devices             │  Transistors, Diodes              │
├──────────────────────┼───────────────────────────────────┤
│  Physics             │  Electrons                        │
└──────────────────────┴───────────────────────────────────┘
```

In this course we will be primarily concerned with **digital circuits**, **logic**, **microarchitecture**, and **architecture**—roughly the middle of this stack. We'll leave device physics to the electrical engineers, and operating systems to another course entirely.

Why does the abstraction stack matter? Because it is what makes the field tractable. A programmer writing a web server doesn't need to know whether the CPU underneath uses silicon or some future material, or whether it has 5 transistors per gate or 5 billion. The architecture layer—the instruction set—is the agreed-upon contract, and everything below it is an implementation detail hidden from above. This course is about understanding what those hidden details actually are.

### A Note on Performance Trends

One practical consequence of this layered design is that improvements at a lower layer—faster transistors, better circuit designs—propagate upward and make every layer above run faster essentially for free. This drove an extraordinary run of performance growth.

From roughly 1986 to 2003, single-processor performance grew at about **52% per year**, meaning it roughly doubled every 18 months. After 2003, the growth rate dropped to about **22% per year**. Why?

Clock speed hit a thermal wall. Processor clock rates climbed from the 80286 (12.5 MHz, ~3W) all the way through the Pentium 4 Prescott (3,600 MHz, 103W), but power scales roughly with the *square* of clock frequency. At 103 watts a processor requires serious active cooling, and pushing further is physically impractical.

The industry's answer was **multicore** design: rather than one very fast core, place two, four, or more moderately fast cores on the same chip, and extract more work from each watt rather than simply increasing frequency. This shift required programmers to write **parallel** code to benefit from multiple cores—a consequence the field is still navigating today.

All of which is to say: the decisions made at the very bottom of the stack—how transistors are built, how fast they switch, how much power they consume—ripple upward and shape everything above them. So before we examine logic gates, it's worth understanding what a gate actually *is* at the physical level.

---

<a id="3"></a>

## Gates, Transistors, Semiconductors, Silicon

Before examining logic gates in detail, it helps to understand the physical chain they sit on top of—what a gate *actually is* when you zoom in far enough.

### The Logic Gate

A **logic gate** is a circuit element that takes one or more binary inputs (voltages representing 0 or 1) and produces a single binary output according to a fixed Boolean function. Here is the standard symbol for an AND gate, which we'll cover properly in the next section:

```
  A ──┐
      ├──── A · B
  B ──┘
```

This symbol is an abstraction. It tells you the interface and the function, but nothing about what's inside. What's inside is transistors.

### Transistors

A **transistor** is a semiconductor device that acts as an electrically controlled switch. Modern processors use **MOSFETs** (Metal-Oxide-Semiconductor Field-Effect Transistors), which have three terminals: a **gate**, a **drain**, and a **source**. When a sufficient voltage is applied to the gate terminal, a conductive channel forms between drain and source and current flows; when the gate voltage is low, the channel closes and current stops. This on/off behavior is exactly the binary switching we need.

Crucially, this switching happens at the atomic scale, repeats billions of times per second, and requires almost no power per individual switch. A modern CPU contains on the order of **tens of billions** of transistors on a chip roughly the size of a fingernail.

Logic gates are built by connecting small numbers of transistors in specific configurations. In CMOS, every gate has two complementary networks: a **pull-down network** connecting the output to ground (logic 0) and a **pull-up network** connecting it to the supply voltage (logic 1). The two networks are always complementary: when one conducts, the other doesn't.

- Transistors in **series** in the pull-down network (all must be ON for current to flow to ground): produces **NAND** behavior
- Transistors in **parallel** in the pull-down network (any one being ON pulls to ground): produces **NOR** behavior

Notice that the natural results are NAND and NOR, not AND and OR. To get AND you'd need a NAND followed by an inverter—two stages instead of one. This is why NAND and NOR are considered the more fundamental building blocks in CMOS: they map directly onto the transistor-level structure with the fewest components.

### Semiconductors and Silicon

Transistors are made from **semiconductor** materials. A semiconductor sits between a conductor (like copper, which carries current freely) and an insulator (like glass, which resists it almost entirely). The useful property of semiconductors is that their conductivity can be *controlled*.

The dominant semiconductor material is **silicon** (Si, element 14). In its pure crystalline form, silicon conducts poorly. The trick is **doping**—deliberately introducing trace amounts of impurity atoms:

- **N-type silicon**: doped with elements that contribute extra free electrons. These electrons are the mobile charge carriers, making the material conduct more readily.
- **P-type silicon**: doped with elements that have one fewer valence electron than silicon, creating **holes**—vacancies in the electron lattice that behave as positive charge carriers moving in the opposite direction.

By layering N-type and P-type silicon in specific geometries, we construct transistors. Those transistors are then etched in enormous numbers onto a thin disc of crystalline silicon called a **wafer**, using a photographic process called **photolithography**. Each wafer yields hundreds of identical chips, which are cut apart and packaged individually.

### Vacuum Tubes: The Historical Predecessor

Before the transistor (invented 1947), computers were built from **vacuum tubes**—glass envelopes evacuated of air, containing a heated cathode that emits electrons, a plate (anode) that collects them, and a control grid in between. Varying the voltage on the grid controls the electron flow from cathode to plate, achieving the same switching function as a transistor.

Vacuum tubes worked, but each one was roughly the size of a lightbulb, ran hot enough to burn you, consumed several watts individually, and failed frequently. ENIAC (1945), one of the first general-purpose electronic computers, used 18,000 vacuum tubes and required a dedicated maintenance team to replace the ones that burned out during operation. The transistor's invention made everything that followed possible.

With that physical foundation in place, we can now treat the gate as what it is at our level of abstraction: a black box that takes binary inputs and produces a binary output. Let's look at each gate in detail.

---

<a id="4"></a>

## Logic Gates

Now we can look at individual gates properly. Each gate has three representations you should be completely comfortable moving between:

1. A **gate symbol** — used in schematic diagrams
2. A **Boolean equation** — used in algebraic manipulation
3. A **truth table** — an exhaustive listing of every possible input combination and its output

These three representations contain exactly the same information expressed differently. As we move through the course you'll regularly need to translate from one form to another.

---

<a id="4-1"></a>

### The NOT Gate

The NOT gate (also called an **inverter**) is the simplest gate: it takes a single input and flips it. A 0 becomes 1, and a 1 becomes 0. The small circle on the output of the symbol is the **inversion bubble**—you'll see this bubble appear on other gates too, always indicating a negation at that point in the circuit.

**Gate symbol:**

```
  A ──▷○── Y
```

**Boolean equation:**

```
Y = Ā   (also written  Y = A',  Y = ¬A,  Y = ~A)
```

**Truth table:**

| A | Y |
|---|---|
| 0 | 1 |
| 1 | 0 |

---

<a id="4-2"></a>

### The AND Gate

The AND gate outputs 1 only when **all** of its inputs are 1. Think of it as the logical equivalent of "both A and B must be true." With two inputs there are four possible input combinations, and only one of them—both inputs high—produces a high output.

**Gate symbol** (flat back, rounded/D-shaped front):

```
  A ──┐
      ├──── Y
  B ──┘
```

**Boolean equation:**

```
Y = AB   (also written  Y = A·B,  Y = A×B,  Y = A∧B)
```

The juxtaposition notation `AB` (no operator symbol) means AND, by direct analogy with multiplication in algebra. This analogy is meaningful: AND really does behave like multiplication over {0, 1}.

**Truth table:**

| A | B | Y |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

---

<a id="4-3"></a>

### The OR Gate

The OR gate outputs 1 when **at least one** input is 1. Unlike everyday English "or" (which sometimes implies exclusivity—"soup or salad, not both"), Boolean OR is *inclusive*: it is true when one input is 1, when the other is 1, or when both are 1.

**Gate symbol** (curved back, pointed front):

```
  A ──┐
      ├──── Y
  B ──┘
```

**Boolean equation:**

```
Y = A + B   (also written  Y = A∨B)
```

The `+` symbol for OR is borrowed from arithmetic. The analogy holds: OR behaves like addition *clamped at 1*, so in Boolean algebra 1 + 1 = 1.

**Truth table:**

| A | B | Y |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 1 |

---

<a id="4-4"></a>

### XOR, NAND, and NOR

Beyond the three fundamental gates (NOT, AND, OR), several derived gates appear so frequently they get their own symbols.

**XOR** ("exclusive OR") outputs 1 when its two inputs *differ*—exactly one of them is 1. It matches everyday English "or" most closely. XOR appears throughout arithmetic circuits because adding two single bits produces a sum bit that is exactly the XOR of the inputs (with a carry-out equal to their AND).

```
Y = A ⊕ B
```

| A | B | Y |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

**NAND** (NOT AND) is an AND gate with an inversion bubble on the output. Its output is 0 only when *all* inputs are 1—the exact complement of AND. Note that the overbar in the Boolean equation must cover the *entire* AND expression, not just one variable:

```
Y = ~(AB)   i.e., NOT of the whole product
```

| A | B | Y |
|---|---|---|
| 0 | 0 | 1 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

**NOR** (NOT OR) is an OR gate with an inversion bubble on the output. Its output is 1 only when *all* inputs are 0. Again, the overbar covers the whole expression:

```
Y = ~(A+B)   i.e., NOT of the whole sum
```

| A | B | Y |
|---|---|---|
| 0 | 0 | 1 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 0 |

> **NAND and NOR are universal gates.** Any logic function can be built using only NAND gates, or alternatively using only NOR gates. In chip fabrication this is useful because an entire design can be implemented in a single cell type, simplifying the manufacturing process significantly.

We now have six gates and a symbol for each. The problem is that as soon as circuits involve more than a handful of gates, drawing diagrams becomes impractical—there's no clean way to write down a function involving twenty gates, let alone reason about whether two different circuits compute the same thing. What we need is an *algebraic language*: a way to express the same information as a formula rather than a picture.

---

<a id="5"></a>

## Boolean Algebraic Notation

Now that we have a vocabulary of gates, we need a way to write down what a circuit *does* without drawing a picture every time. That's what **Boolean algebra** gives us: a symbolic language for describing logic functions using variables, operators, and parentheses—just like ordinary algebra, but where every variable is either 0 or 1, and the operators correspond directly to gates.

The catch is that several different communities (mathematicians, electrical engineers, and programmers) developed their own notation for the same operations, and all of them remain in common use. Here is a unified reference:

| Operation | Notations you will encounter |
|-----------|------------------------------|
| NOT A     | `~A` &nbsp; `¬A` &nbsp; `Ā` &nbsp; `A'` |
| A AND B   | `A & B` &nbsp; `A ∧ B` &nbsp; `A · B` &nbsp; `AB` (juxtaposition) |
| A OR B    | `A \| B` &nbsp; `A ∨ B` &nbsp; `A + B` |
| A XOR B   | `A ^ B` &nbsp; `A ⊕ B` |

The `+` for OR and juxtaposition for AND come from Boolean's original mathematical framing. The `~`, `&`, and `|` come from C and most programming languages. The `¬`, `∧`, and `∨` come from formal logic. You'll encounter all of them in textbooks, datasheets, and code.

### Operator Precedence

Boolean expressions have a defined evaluation order when parentheses are absent, from highest to lowest binding:

1. **NOT** — applied to its immediate operand first
2. **AND**
3. **OR** — loosest binding

So `Ā · B + C` means `((NOT A) AND B) OR C`, not `NOT(A AND (B OR C))`. When there is any potential ambiguity, use parentheses—both for correctness and for the reader's sake.

### Boolean Identities

Because every variable is either 0 or 1, Boolean algebra has identities that look strange from an arithmetic perspective but are trivially verified by checking both cases:

```
A · 0  = 0          A + 0  = A          (identity elements)
A · 1  = A          A + 1  = 1          (identity elements)
A · A  = A          A + A  = A          (idempotence)
A · Ā  = 0          A + Ā  = 1          (complement)
```

These let you simplify Boolean expressions—swapping a complex sub-expression for a simpler equivalent—without changing the function the circuit computes. Simplifying an expression often means the circuit can be built with fewer gates.

### DeMorgan's Theorem

The single most useful simplification rule is **DeMorgan's Theorem**. It states that negating an entire AND expression is the same as OR-ing the individual negations, and vice versa:

```
NOT (A AND B)  =  (NOT A)  OR  (NOT B)
NOT (A  OR B)  =  (NOT A) AND  (NOT B)
```

In compact notation:

```
~(AB)   =  Ā + B̄
~(A+B)  =  Ā · B̄
```

You can verify either identity by writing out the truth table for both sides—they match for every input combination.

Why does this matter in practice? Consider the NAND gate, whose output is `~(AB)`. DeMorgan's says that is *identical* to `Ā + B̄`—an OR gate with individually inverted inputs. These two circuits compute exactly the same function from the same inputs. Designers exploit this equivalence deliberately: they'll draw a gate one way in a schematic and label it the other way to make the *intent* of the logic clearer. This technique is called **bubble pushing**, and you cannot read professional schematics without knowing DeMorgan's.

The algebra and the circuit diagram are two views of the same object. A third view—the truth table—lists every possible input combination and its output exhaustively. Being able to move fluently between all three is the foundation of circuit analysis, so let's work through a complete example.

---

<a id="6"></a>

## Circuit Analysis: Deriving Expressions and Truth Tables

Now that we have a gate vocabulary, an algebraic notation, and the tools to simplify expressions, we can put it all together. The goal of circuit analysis is to move freely between a **circuit diagram**, a **Boolean expression**, and a **truth table**—three representations of the same underlying function. Being fluent in all three is a core skill for this course.

The process for deriving a Boolean expression from a circuit is straightforward: starting at the inputs, label each wire with the expression it carries, working gate by gate from left to right, until you reach the output.

### Example

Here is the circuit from the lecture slides, with inputs A, B, C, D and output Y:

```
  A ──○─┐
        ├──[AND]──── W1 ──┐
  B ──○─┘                  ├──[AND]──── W2 ──┐
                            │                  ├──[NOR]──── Y
  C ─────────────────────────                  │
                                               │
  D ────────────────────────────────────────────
```

The small circles (`○`) on the A and B input wires are **inversion bubbles**—the same symbol as the circle on the output of a NOT gate. They mean "negate this signal before it enters the gate." So A does not enter the first AND gate as A; it enters as NOT A. Same for B.

The wires W1 and W2 are internal signals with no connection to the outside world—they exist only to carry a value from one gate to the next. Our job is to figure out what expression each one carries.

**Step 1 — What does W1 carry?**

The first AND gate takes two inputs: NOT A (because of the bubble on A's wire) and NOT B (same reason). An AND gate outputs 1 only when all its inputs are 1, so:

```
W1 = (NOT A) AND (NOT B)  =  ~A & ~B
```

In other words, W1 is 1 only when both A and B are 0.

**Step 2 — What does W2 carry?**

The second AND gate takes W1 and C as inputs—no inversion bubbles on either wire this time. So:

```
W2 = W1 AND C  =  (~A & ~B) & C  =  ~A & ~B & C
```

Substituting what we found for W1, W2 is 1 only when A is 0, B is 0, *and* C is 1—all three conditions simultaneously.

**Step 3 — What does Y carry?**

W2 and D both feed into a NOR gate. From Section 4, a NOR gate outputs NOT of the whole OR: `Y = ~(W2 OR D)`. Substituting W2:

```
Y = ~(W2 + D)  =  ~((~A & ~B & C) + D)
```

This is a valid, complete answer. But the negated form is hard to read—it describes when Y is *not* true rather than when it *is* true. Let's use DeMorgan's theorem to push the outer NOT inside and get a cleaner expression.

DeMorgan's says `~(P + Q) = ~P & ~Q`. Applying that here, where P = `(~A & ~B & C)` and Q = `D`:

```
~((~A & ~B & C) + D)  =  ~(~A & ~B & C)  &  ~D
```

Now apply DeMorgan's again to expand `~(~A & ~B & C)`. DeMorgan's says `~(P & Q & R) = ~P + ~Q + ~R`, so we negate each term individually:

```
~(~A & ~B & C)  =  ~~A + ~~B + ~C  =  A + B + ~C
```

`~A` becomes `~~A = A` (double negation cancels). `~B` becomes `~~B = B` (same). `C` — which had *no* negation in the original — becomes `~C`. This last point is the one to be careful about: DeMorgan's negates *every* term, including ones that were already positive.

Putting it back together:

```
Y  =  (A + B + ~C)  &  ~D
```

This is a valid expression, but product-of-sums form is harder to work with than the alternative. More useful for our purposes is **sum-of-products (SOP)** form: a list of AND-terms OR'd together, where each AND-term describes one specific combination of inputs that makes Y equal to 1.

We can read the SOP form directly from the truth table we're about to build: find every row where Y=1, write an AND-term for each one, and OR them all together. But we can also see it algebraically. The full expression `~((~A & ~B & C) + D)` equals 1 exactly when the OR inside equals 0 — meaning both `(~A & ~B & C)` is 0 and `D` is 0. Y is 0 only when D=1 and W2=1 simultaneously. In every other row, Y is 1 — either because D=0, or because D=1 but W2=0. Written as the OR of those conditions:

```
Y = (~A & ~B & C) | ~D
```

In compact Boolean notation: **Y = ĀB̄C + D̄**

Reading this aloud: "Y is 1 when (A is 0 and B is 0 and C is 1), *or* when D is 0." The `~D` term alone accounts for half the truth table—any time D is 0, Y is 1, regardless of what A, B, or C are doing. The `~A & ~B & C` term covers the one remaining row (A=0, B=0, C=1, D=1) where D is 1 but Y should still be 1.

This format—a sum of AND-terms, each AND-term being a product of individual (possibly inverted) inputs—is called **sum-of-products (SOP)** form. It is the standard way to express a combinational logic function, and it is the form you will use throughout this course when analyzing or designing circuits.

### Building the Truth Table

Once we have the expression, generating the truth table is mechanical: enumerate every possible input combination and evaluate the expression for each one.

With four inputs there are **2⁴ = 16** combinations. The general rule is *n* input variables → **2ⁿ rows**. A reliable enumeration strategy is to treat the inputs as a binary counter from 0000 to 1111—this guarantees every combination appears exactly once.

The table below shows two intermediate sub-expression columns so the evaluation is fully traceable:

| A | B | C | D | `~A & ~B & C` | `~D` | Y = (`~A & ~B & C`) \| `~D` |
|---|---|---|---|:---:|:---:|:---:|
| 0 | 0 | 0 | 0 | 0 | 1 | **1** |
| 0 | 0 | 0 | 1 | 0 | 0 | **0** |
| 0 | 0 | 1 | 0 | 1 | 1 | **1** |
| 0 | 0 | 1 | 1 | 1 | 0 | **1** |
| 0 | 1 | 0 | 0 | 0 | 1 | **1** |
| 0 | 1 | 0 | 1 | 0 | 0 | **0** |
| 0 | 1 | 1 | 0 | 0 | 1 | **1** |
| 0 | 1 | 1 | 1 | 0 | 0 | **0** |
| 1 | 0 | 0 | 0 | 0 | 1 | **1** |
| 1 | 0 | 0 | 1 | 0 | 0 | **0** |
| 1 | 0 | 1 | 0 | 0 | 1 | **1** |
| 1 | 0 | 1 | 1 | 0 | 0 | **0** |
| 1 | 1 | 0 | 0 | 0 | 1 | **1** |
| 1 | 1 | 0 | 1 | 0 | 0 | **0** |
| 1 | 1 | 1 | 0 | 0 | 1 | **1** |
| 1 | 1 | 1 | 1 | 0 | 0 | **0** |

A few things worth noticing. The `~A & ~B & C` column is 1 in only two rows (rows 3 and 4, where A=0, B=0, C=1). The `~D` column is 1 in all eight rows where D=0. The OR of these two columns is 1 in any row where *at least one* of them is 1—which is every row except those where D=1 and `~A & ~B & C` is also 0. This matches exactly what we'd expect from the expression.

> As circuits grow more complex, truth tables become impractical quickly. A circuit with 32 inputs would require over four billion rows. That is why the Boolean expression—and the algebraic tools for simplifying it—is the primary instrument for circuit analysis.

So we now have a clean algebraic expression for what our circuit computes. The next question is: how do we actually *build* it? Drawing a schematic by hand and handing it to a fabrication plant is not how hardware gets made. We need a way to describe the circuit in a form a computer can process, verify, and pass to fabrication tools. That's what hardware description languages are for.

---

<a id="7"></a>

## Hardware Description: Verilog

So far we've described circuits graphically and algebraically. To actually *build* a circuit—on a physical chip or a programmable logic device—we need to express it in a form a computer can process. That is the role of a **hardware description language (HDL)**.

**Verilog** is one of the two dominant HDLs in industry (the other is VHDL). It looks superficially like C, which can be misleading. The critical difference: a C program describes a *sequence of instructions that execute over time*. A Verilog description specifies a *set of components and their connections that all exist simultaneously*. When you write Verilog, you are not writing code that runs—you are writing a specification of a circuit that will be built.

We'll work through describing our running example in both styles of Verilog:

```
Y = ĀB̄C + D̄
```

---

<a id="7-1"></a>

### Structural Verilog

**Structural** Verilog describes a circuit explicitly in terms of named gate instances and the wires connecting them. It is the closest Verilog style to drawing a schematic—every gate and every wire appears by name.

A Verilog design is organized into **modules**. A module is the fundamental building block: a component with a defined interface to the outside world and some internal implementation. Think of it as a black box with labeled pins.

```verilog
module MyCircuit(A, B, C, D, Y);
    input  A, B, C, D;
    output Y;
```

The name after `module` is the module's identifier. The parenthesized list is the **port list**—every signal that crosses the module boundary must appear here. The `input` and `output` declarations specify each port's direction: A, B, C, D bring signals in; Y carries the result out.

Next we declare internal wires—signals that exist only inside the module to connect its subcomponents:

```verilog
    wire W1, W2;
```

`W1` and `W2` correspond directly to the labeled wires in our circuit diagram from Section 6. They are not visible from outside the module.

Now we instantiate the gates. The syntax is:

```
gate_type  instance_name ( output_port, input_port1, input_port2, ... );
```

The **first** argument is always the output; the remaining arguments are inputs. The order of these statements is irrelevant—all gates *exist simultaneously*, as they would in physical hardware.

Because our circuit inverts A, B, and D before feeding them into other gates, we need explicit `not` instances for those signals:

```verilog
    not NA (nA, A);            // nA = ~A
    not NB (nB, B);            // nB = ~B
    not ND (nD, D);            // nD = ~D
    and A1 (W1, nA, nB);       // W1 = ~A & ~B
    and A2 (W2, W1,  C);       // W2 = W1 & C  =  ~A & ~B & C
    or  O1 (Y,  W2, nD);       // Y  = W2 | ~D
endmodule
```

Unlike the `assign` style we'll see next, gate-level instantiation in Verilog does not allow expressions like `~A` directly in a port list—each signal must be a named wire. The `not` gate instances create named wires (`nA`, `nB`, `nD`) that carry the inverted values, which are then passed to the downstream gates.

---

<a id="7-2"></a>

### Continuous Assignment Verilog

Structural Verilog is precise but verbose for simple circuits. For **combinational logic**—circuits whose output depends only on the *current* inputs, with no memory or feedback—we can use a more compact style.

The term *combinational* is worth pausing on. It distinguishes these circuits from *sequential* circuits, which have memory (their output depends on past inputs as well as present ones). Everything we've built so far is combinational. Flip-flops and registers, which we'll cover in a later lecture, are sequential.

**Continuous assignment** lets us write the Boolean expression almost directly:

```verilog
module MyCircuit(A, B, C, D, Y);
    input  A, B, C, D;
    output Y;

    assign Y = (~A & ~B & C) | ~D;
endmodule
```

The `assign` statement means: *"Y is continuously driven by the value of this expression."* Whenever any input changes, Y immediately re-evaluates. There is no clock, no sequence of steps—the output tracks the inputs instantaneously (in the ideal model; real gates have small **propagation delays**, which we'll revisit later in the course).

Both versions of `MyCircuit` describe exactly the same circuit and produce equivalent hardware. The operator mapping from Boolean notation to Verilog is:

| Boolean | Verilog |
|---------|---------|
| `Ā`     | `~A`    |
| `AB`    | `A & B` |
| `A + B` | `A \| B`|
| `A ⊕ B` | `A ^ B` |

Operator precedence in Verilog follows C: `~` binds tightest, then `&`, then `^`, then `|`. This matches Boolean precedence (NOT > AND > OR), so Boolean expressions translate directly—but always parenthesize explicitly to make intent clear.

---

<a id="7-3"></a>

### Synthesis

Writing Verilog is only the first step. To turn a description into actual hardware, we run it through a **synthesis** tool. Synthesis takes your Verilog and produces a **netlist**: a lower-level description of the circuit as primitive gates (or, for FPGAs, lookup tables) that can be sent to a manufacturer or loaded onto a device.

A popular open-source synthesis framework is **Yosys**. Feed it either version of `MyCircuit` and it produces a gate-level diagram:

```
[Verilog source] ──→ [ yosys ] ──→ [gate-level netlist + diagram]
```

Two observations from the synthesized diagrams in the lecture slides:

First, both Verilog versions—structural and continuous assignment—produce equivalent netlists. This confirms that the two styles are genuinely interchangeable descriptions of the same hardware.

Second, Yosys may **optimize** the circuit. It might reorder or merge gates in ways that use fewer transistors while preserving the truth table for all inputs. This process is called **logic minimization**, and it is one of the primary jobs of a synthesis tool. A circuit that appears to need five gates in your source might emerge from synthesis as three. This is why expressing the *correct Boolean function* matters more than how efficiently you initially write it down—the tool finds an optimized implementation for you.

We've now covered the full pipeline from a Boolean expression on paper to hardware on a chip. But we've been treating our gates as operating on abstract 0s and 1s. In a real computer, those bits represent something—integers, instructions, memory addresses. Before we can talk about what circuits *do* at any meaningful level, we need to understand how numbers are encoded in binary.

---

<a id="8"></a>

## Representing Numbers in Binary

Now that we've grounded logic gates in hardware and algebra, we can ask a broader question: how do we represent *numbers* in a system that only understands 0s and 1s?

The answer is **positional notation**—the same principle underlying our everyday decimal system, but using base 2 instead of base 10.

In **decimal** (base 10), the value of each digit depends on its position. The rightmost digit is the ones place (10⁰ = 1), the next is the tens place (10¹ = 10), then hundreds (10²), and so on. The number 347 means:

```
3 × 10²  +  4 × 10¹  +  7 × 10⁰
= 300     +  40       +  7
= 347
```

**Binary** (base 2) works identically, but each position represents a power of 2, and each digit—called a **bit**—can only be 0 or 1. The positions from right to left are the 1s place (2⁰), 2s place (2¹), 4s place (2²), 8s place (2³), and so on.

### Number Base Prefixes

When writing numbers in code or technical documents, we need a way to tell the reader which base a number is written in—since `11` means something very different in binary (3) vs. decimal (11). The conventions are:

| Base | Name        | Allowed digits | Prefix       |
|------|-------------|----------------|--------------|
| 10   | Decimal     | 0–9            | none (or `0d`, optional) |
| 2    | Binary      | 0, 1           | `0b` (required) |
| 16   | Hexadecimal | 0–9, A–F       | `0x` or `0h` (required) |

So `0b1010` is the binary number 1010 (= 10 in decimal), and `0xFF` is the hexadecimal number FF (= 255 in decimal). When there's no prefix, decimal is assumed. We'll cover hexadecimal in Section 10.

### Binary to Decimal

To convert a binary number to decimal, multiply each bit by its positional power of 2 and sum the results.

**Example:** Convert `0b11001` to decimal.

```
Position:  4    3    2    1    0
Bit:       1    1    0    0    1

1 × 2⁴ = 16
1 × 2³ =  8
0 × 2² =  0
0 × 2¹ =  0
1 × 2⁰ =  1
         ───
          25
```

So **0b11001 = 25₁₀**.

A useful mental shortcut: the powers of 2 from right to left are 1, 2, 4, 8, 16, 32, 64, 128, .... Sum the positional values wherever a 1 bit appears.

### Decimal to Binary

Going the other direction—from decimal to binary—requires a different method. The standard algorithm is **repeated division by 2**. Divide the number by 2, record the remainder (which is always 0 or 1), then repeat on the quotient until you reach 0. The binary representation is the remainders read from *bottom to top*.

The remainders come out in reverse order because each division strips off the least-significant bit first. Reading them bottom-to-top reassembles the number with the most-significant bit at the left.

**Example:** Convert 25 to binary.

| Division | Quotient | Remainder |
|----------|----------|-----------|
| 25 ÷ 2   | 12       | **1**     |
| 12 ÷ 2   | 6        | **0**     |
| 6 ÷ 2    | 3        | **0**     |
| 3 ÷ 2    | 1        | **1**     |
| 1 ÷ 2    | 0        | **1**     |

Reading the remainders from bottom to top: **11001**. So 25₁₀ = **0b11001**.

You can verify by converting back: 16 + 8 + 0 + 0 + 1 = 25 ✓

### Terminology

A few terms that will appear constantly going forward:

- A single binary digit is a **bit**
- A group of 4 bits is a **nibble**
- A group of 8 bits is a **byte**
- A **word** is a grouping whose size depends on the architecture—commonly 32 or 64 bits on modern systems

Knowing how integers are stored in binary lets us do something powerful: apply our logic gates directly to those integer representations, bit by bit. That's exactly what bitwise operations are.

---

<a id="9"></a>

## Bitwise Operations

With binary representation established, we can apply our logic gates to entire integers at once. A **bitwise operation** takes two integers, lines up their binary representations, and applies a Boolean gate independently to each pair of corresponding bits. The positions do not interact with each other—there is no carry, no overflow, no propagation from one column to the next.

This distinguishes bitwise operations from both *logical* operations (which treat any nonzero integer as a single "true") and *arithmetic* operations (which carry across bit positions). Bitwise operations give you precise, direct control over individual bits within a value—something arithmetic cannot do cleanly—and they execute in a single CPU instruction regardless of the integer's size.

---

### Bitwise AND (`&`)

For each bit position, the result is 1 if and only if **both** input bits at that position are 1.

**Example: `10 & 6`**

Convert both to binary, align them, apply AND column by column:

```
  10  →  1 0 1 0
   6  →  0 1 1 0
         ───────
  &      0 0 1 0  →  2
```

`10 & 6 == 2`. The only position where both inputs had a 1 was position 1 (the 2s place).

Bitwise AND is the standard **masking** tool: by AND-ing a value with a pattern of 1s and 0s, you isolate the bits you care about and zero out everything else.

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

`10 | 6 == 14`. Every position where at least one input had a 1 becomes 1 in the output.

Bitwise OR is the standard tool for **setting** specific bits: OR-ing with a mask turns on the bits that are 1 in the mask while leaving all other bits unchanged.

---

### Bitwise NOT (`~`)

Flips every bit: 0 becomes 1 and 1 becomes 0.

**Important caveat:** the result depends on the integer type's bit-width. In C, `int` is typically 32 bits, so `~` flips all 32. Combined with two's complement signed representation (covered in a later lecture), this makes `~x` equal to `-(x+1)` for signed integers.

**Example: `~10` as a 4-bit unsigned value**

```
  10  →  1 0 1 0
         ───────
  ~      0 1 0 1  →  5
```

`~10 == 5` for a 4-bit unsigned integer. In 32-bit C, `~10 == -11`. Keep the bit-width in mind whenever you use `~`.

---

### Practical Applications

Here are two examples from the slides that connect bitwise operations directly to the binary representation concepts above.

**Is a number odd or even?**

In binary, the least-significant bit (the 2⁰ place, also called the **LSB**) determines parity. An odd number always has LSB = 1; an even number always has LSB = 0. This is simply because "even" means divisible by 2, and the only bit that carries the 2⁰ value is the last one.

We test the LSB by AND-ing with the mask `1` (binary `...00001`), which zeroes out every bit except the LSB:

```c
bool is_odd(int x) {
    return (x & 1) == 1;
}
```

The parentheses around `x & 1` are required. In C, `==` has *higher* precedence than `&`, so without them `x & 1 == 1` is parsed as `x & (1 == 1)`, which simplifies to `x & 1`—accidentally correct here, but for the wrong reason and not reliably so with other masks. Always parenthesize bitwise sub-expressions explicitly.

**Round down to the nearest multiple of four:**

Any multiple of 4 in binary ends in `...00`—its two least-significant bits are zero—because 4 = 100₂ and multiplying by any integer only shifts that pattern left. For example: 4 = `100`, 8 = `1000`, 12 = `1100`, 16 = `10000`.

To force any integer down to the nearest multiple of 4, we zero out its two LSBs while leaving everything else unchanged. The mask we need has 1s everywhere *except* the last two positions. Since 3 in binary is `...000011`, its complement `~3` is `...111100`, which is exactly that mask:

```c
int align_to_4(int x) {
    return x & ~3;
}
```

**Verification** (using 6 bits for clarity):

```
align_to_4(10):  001010 & ~(000011)  =  001010 & 111100  =  001000  =   8  ✓
align_to_4(20):  010100 & ~(000011)  =  010100 & 111100  =  010100  =  20  ✓
```

For 10 (binary `001010`), the LSBs were `10`, which get zeroed to give `001000` = 8. For 20 (binary `010100`), the LSBs were already `00`, so the AND leaves the value unchanged.

The general pattern `x & ~(n-1)` aligns `x` down to the nearest multiple of any power-of-two `n`. You will see this in memory allocators, hardware register programming, and cache-line alignment throughout systems software.

All of these operations—the masking, the alignment, the checking—work directly on the binary representation of integers. But there's a practical problem: binary is exhausting to read and write. A 32-bit memory address written out as 32 ones and zeros is nearly impossible to parse at a glance. Programmers needed a shorthand that maps cleanly onto binary without losing precision. That shorthand is hexadecimal.

---

<a id="10"></a>

## Hexadecimal

Binary is the native language of hardware, but it's not very human-friendly. A 32-bit value written in binary is a wall of 32 ones and zeros that's difficult to read, write, or remember. **Hexadecimal** (base 16, abbreviated *hex*) solves this problem: because 16 = 2⁴, each hex digit represents exactly 4 binary bits, so any binary number can be transcribed directly into hex without any arithmetic—just a digit-for-digit substitution.

Hex uses the digits 0–9 for the values zero through nine, then A–F for the values ten through fifteen:

| Decimal | Binary | Hex |
|---------|--------|-----|
| 0       | 0000   | 0   |
| 1       | 0001   | 1   |
| 2       | 0010   | 2   |
| 3       | 0011   | 3   |
| 4       | 0100   | 4   |
| 5       | 0101   | 5   |
| 6       | 0110   | 6   |
| 7       | 0111   | 7   |
| 8       | 1000   | 8   |
| 9       | 1001   | 9   |
| 10      | 1010   | A   |
| 11      | 1011   | B   |
| 12      | 1100   | C   |
| 13      | 1101   | D   |
| 14      | 1110   | E   |
| 15      | 1111   | F   |

This table is worth memorizing. Once you know it, converting between binary and hex is instantaneous.

### Binary to Hexadecimal

Split the binary number into groups of 4 bits starting from the right. Convert each group independently using the table above. If the leftmost group has fewer than 4 bits, pad it with leading zeros.

**Example:** Convert `0b1101 1001` to hexadecimal.

The number is already split into two 4-bit groups:

```
1101  →  13  →  D
1001  →   9  →  9
```

Result: **0xD9**

### Hexadecimal to Binary

Go in reverse: replace each hex digit with its 4-bit binary equivalent, keeping the groups in order.

**Example:** Convert `0xA7F1` to binary.

```
A  →  10  →  1010
7  →   7  →  0111
F  →  15  →  1111
1  →   1  →  0001
```

Result: **0b 1010 0111 1111 0001**

Notice that the spaces between groups are just for readability—`0b1010011111110001` and `0b 1010 0111 1111 0001` represent the same value.

### Why Hex Matters in Practice

Any time you see a memory address, a color code (`#FF8800`), a network MAC address, or a register dump in a debugger, it's almost certainly written in hex. The prefix `0x` is your signal. Being able to quickly read hex—and convert between hex and binary mentally—is a skill you'll use constantly in systems programming and hardware work.

There's one more piece of the number-representation puzzle we haven't addressed: everything so far has been non-negative. Real programs subtract, negate, and compare signed values constantly. The question of how to encode negative numbers in binary turns out to have a surprisingly elegant answer.

---

<a id="11"></a>

## Two's Complement

We could reserve one bit as a sign bit and use the remaining bits for the magnitude, but this approach has a fatal flaw: it produces two representations of zero (`+0` and `-0`) and makes addition circuits complicated. Instead, virtually all modern hardware uses **two's complement**, a clever encoding that avoids both problems.

### The Core Idea: Fixed Bit-Width

Two's complement only makes sense in the context of a *fixed* number of bits. If we're working with 4-bit numbers, we have exactly 2⁴ = 16 possible bit patterns (0000 through 1111) and we need to decide what value each one represents.

In two's complement, we assign the values like this for a 4-bit system:

| Bit pattern | Two's complement value |
|-------------|----------------------|
| 0000        | 0                    |
| 0001        | 1                    |
| 0010        | 2                    |
| 0011        | 3                    |
| 0100        | 4                    |
| 0101        | 5                    |
| 0110        | 6                    |
| 0111        | 7                    |
| 1000        | −8                   |
| 1001        | −7                   |
| 1010        | −6                   |
| 1011        | −5                   |
| 1100        | −4                   |
| 1101        | −3                   |
| 1110        | −2                   |
| 1111        | −1                   |

Two things to notice immediately. First, the **most significant bit (MSB)** tells you the sign: if the MSB is 0, the number is non-negative; if it's 1, the number is negative. Second, there are 8 non-negative values (0 through 7) and 8 negative values (−8 through −1)—the range is asymmetric. There is one more negative number than there are positive numbers. This is an inherent property of two's complement.

> **Bit-width warning:** Two's complement only works within a fixed bit-width. If a number requires more bits than your field provides, the extra high-order bits are simply discarded — a process called **truncation**. For example, 20 in binary is `0b10100`, which is 5 bits. Stored in a 4-bit field, the leading 1 is dropped, leaving `0100` = 4. The value has been silently corrupted. This is distinct from *overflow*, which refers to an arithmetic result that exceeds the representable range (covered below).

### Why This Encoding?

The brilliant property of two's complement is that **ordinary binary addition works correctly for both positive and negative numbers without any special cases**. The addition circuit doesn't need to know whether its inputs are signed or unsigned—it just adds bits and ignores any carry out of the top position. This is why every CPU uses two's complement.

For example, in 4-bit two's complement: 3 + (−3) should equal 0.

```
  0011   (3)
+ 1101   (−3)
──────
  0000   (0, with a carry of 1 out of the top — discarded)
```

The carry is thrown away and the result is 0. It works.

### Decimal to Two's Complement

To convert a negative decimal number to its two's complement binary representation in *n* bits:

**Step 1.** Convert the absolute value to binary (using the repeated-division method from Section 8), padded to *n* bits.

**Step 2.** Invert every bit (flip all 0s to 1s and all 1s to 0s).

**Step 3.** Add 1 to the result.

**Example:** Represent −3 in 4-bit two's complement.

```
Step 1. |−3| = 3 → 0011   (4-bit binary for 3)

Step 2. Invert all bits:
        0011  →  1100

Step 3. Add 1:
        1100
      + 0001
      ──────
        1101
```

Result: −3 is represented as **1101** in 4-bit two's complement. Checking against the table above: ✓

### Two's Complement to Decimal

To convert a two's complement binary number back to a signed decimal:

**Step 1.** Check the MSB. If it's 0, the number is non-negative—convert normally using the positional method from Section 8 and you're done.

**Step 2.** If the MSB is 1, the number is negative. Invert all bits.

**Step 3.** Add 1 to the result.

**Step 4.** Convert to decimal and apply a minus sign.

**Example:** Convert `1101` (4-bit two's complement) to decimal.

```
Step 1. MSB = 1, so the number is negative.

Step 2. Invert all bits:
        1101  →  0010

Step 3. Add 1:
        0010
      + 0001
      ──────
        0011

Step 4. Convert 0011 to decimal: 2 + 1 = 3. Apply minus sign: −3.
```

Result: **1101₂ = −3** in 4-bit two's complement. ✓

Notice that the encode and decode procedures are symmetric—applying the same three steps twice gets you back where you started. This is not a coincidence; it's a mathematical property of the encoding.

### The Range of an n-Bit Two's Complement Number

For a signed integer stored in *n* bits, the representable range is:

```
−2^(n−1)  to  2^(n−1) − 1
```

For 4 bits: −8 to 7. For 8 bits: −128 to 127. For 32 bits: −2,147,483,648 to 2,147,483,647. The negative end always reaches one further than the positive end because zero takes one of the non-negative slots.

This range is why the `int` overflow bug exists: adding two large positive 32-bit integers can produce a result that exceeds 2,147,483,647, wrapping around to a large negative number. Understanding two's complement is the prerequisite for understanding why that happens.
