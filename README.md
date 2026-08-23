# DSP48A1-implementation-
# DSP48A1-Project

## Spartan-6 DSP48A1 with Parameterized Pipeline Registers

A Verilog implementation of the Xilinx Spartan-6 **DSP48A1** hard macro,
targeting `xc7a200tffg1156-3`. The design rebuilds the primitive's internal
data path — pre-adder, 18×18 multiplier, operand-select muxes, post-ALU —
from a small library of reusable RTL blocks, with every pipeline register
independently enabled and reset, matching the configurability of the real
chip.

## Features

- Full DSP48A1 port list: `A`, `B`, `C`, `D`, `BCIN`, `PCIN`, `OPMODE`,
  `CARRYIN`, per-stage clock enables and resets
- 11 independently configurable pipeline register stages (`A0`, `A1`, `B0`,
  `B1`, `C`, `D`, `M`, `P`, `CARRYIN`, `CARRYOUT`, `OPMODE`)
- 18×18 two's-complement multiplier with pre-adder/subtracter and
  post-adder/subtracter (ALU) stages
- `OPMODE`-driven operand selection (4:1 muxes) for accumulate, cascade, and
  direct-input modes, matching the real primitive's opmode encoding
- Cascade support (`BCOUT`/`BCIN`, `PCOUT`/`PCIN`) for chaining DSP slices
- Fully synchronous design, single clock domain, `SYNC`/`ASYNC` reset
  selectable per instantiation
- Verified in simulation with a self-checking directed testbench
- Carried through Vivado synthesis and implementation; multiply path
  correctly infers onto a single hardened DSP48E1 slice

## Architecture

![DSP48A1 architecture diagram](readme/DSP_Arch.png)

`REG_BLK` is the core building block of the design: it pairs a generic
`REG` with a `ParamMux` so that any pipeline stage can be compile-time
configured as either registered or a pass-through wire. Every register in
the DSP48A1 — both `A`/`B` input stages, `C`, `D`, the multiplier output
`M`, the final result `P`, `CARRYIN`, `CARRYOUT`, and `OPMODE` — is one
instance of `REG_BLK`, parameterized independently.

Data flows as: `A`/`B`/`C`/`D` are optionally registered, `B` and `D` feed a
pre-adder/subtracter (`OPERATOR`) whose result can replace `B` before the
second-stage `B1`/`A1` registers; `A1` and `B1` feed the 18×18 multiplier
into `M`. Two 4:1 muxes (`MUX_X`, `MUX_Z`), selected by `OPMODE`, choose the
post-ALU's operands from `M`, the registered output `P` (for accumulation),
the concatenated `D:A:B` path, `PCIN`, or `C`. A second `OPERATOR` instance
computes the final add/subtract with a selectable carry-in, and the result
is optionally registered into `P`/`PCOUT`.

## OPMODE Encoding

| OPMODE bit(s) | Meaning |
|---|---|
| `OPMODE[7]` | Post-ALU add/subtract select |
| `OPMODE[6]` | Pre-adder add/subtract select |
| `OPMODE[5]` | Carry-in select (when `CARRYINSEL = "OPMODE5"`) |
| `OPMODE[4]` | Selects pre-adder result vs. raw `B` into `B1` |
| `OPMODE[3:2]` | `MUX_Z` operand select (`PCIN`, `P`, `C`, unused) |
| `OPMODE[1:0]` | `MUX_X` operand select (`M`, `P`, `D:A:B`, unused) |

`OPMODE` is itself registered (`OPMODE_REG`) before it drives any mux or
adder, so control decisions are pipelined in step with the data.

## Data Path Stages

1. **Input registers** — `A0`, `B0` (or `BCIN` when cascaded), `C0`, `D0`,
   `OPREG` latch the inputs.
2. **Pre-adder** — computes `D0 ± B0`; `MUX21` selects it or raw `B0` into `B1`.
3. **Multiply** — `A1 × B1` → `M` (optionally registered).
4. **Carry select** — `CARRYINSEL` picks `CARRYIN` or `OPMODE[5]` as the ALU carry-in.
5. **Operand select** — `MUX_X`/`MUX_Z` choose the post-ALU's two operands.
6. **Post-ALU** — `Z ± X` with the selected carry-in.
7. **Output registers** — result → `P`/`PCOUT`; carry → `CARRYOUT`/`CARRYOUTF`.

All stages return to their pipelined values every clock; there is no
handshaking or wait states — the block is purely a fixed-latency, fully
synchronous pipeline.

## Verification

`DSP48A1_tb` is a self-checking testbench that exercises four directed
vectors — add, subtract, multiply-only, and multiply-accumulate with carry —
and checks `P`, `M`, `BCOUT`, `PCOUT`, `CARRYOUT`, and `CARRYOUTF` against
hand-computed expected values after each. All directed tests pass.

## Hardware / Implementation

`constraints.xdc` sets a 100 MHz clock constraint on `CLK` for synthesis
targeting `xc7a200tffg1156-3`. Synthesis and implementation both complete
with 0 errors and all timing constraints met; the multiplier is correctly
inferred onto a single hardened `DSP48E1` primitive rather than fabric
logic.
```
