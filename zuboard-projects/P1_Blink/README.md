# P1_Blink

`P1_Blink` is the first ZUBoard 1CG hardware project in this repo. It is a
small Vivado block-design project that uses custom Verilog in the PL to cycle
the two on-board RGB LEDs through all 8 RGB bit patterns.

The main learning goal is to get comfortable with the Vivado hardware flow:
board selection, RTL sources, block design integration, pin constraints,
simulation, implementation, bitstream generation, and USB/JTAG programming.

## Hardware Target

- Board: Avnet ZUBoard 1CG
- Device: `xczu1cg-sbva484-1-e`
- Tool used for the checked-in run: Vivado `2024.2`
- Programming path: USB/JTAG through Vivado Hardware Manager

## Design Summary

The design uses the Zynq UltraScale+ MPSoC processing system only as a PL clock
source. The custom `blink` RTL runs in programmable logic and drives the RGB LED
pins directly.

```text
Zynq UltraScale+ PS
  pl_clk0 @ 100 MHz
        |
        v
blink.v
        |
        v
rgb_led0_0[2:0], rgb_led1_0[2:0]
        |
        v
ZUBoard RGB LED pins
```

The block design contains:

- `zynq_ultra_ps_e_0`: provides `pl_clk0`.
- `blink_0`: an HDL module reference created from `blink.v`.
- External outputs: `rgb_led0_0[2:0]` and `rgb_led1_0[2:0]`.

## Important Files

```text
P1_Blink.xpr
    Vivado project file.

P1_Blink.srcs/sources_1/new/blink.v
    Hand-written RTL for the LED state machine.

P1_Blink.srcs/sim_1/new/blink_tb.v
    Simple behavioral testbench for the blink module.

P1_Blink.srcs/constrs_1/new/zuboard_pins.xdc
    Physical RGB LED pin constraints.

P1_Blink.srcs/sources_1/bd/blink_bd/blink_bd.bd
    Vivado block design.

P1_Blink.gen/sources_1/bd/blink_bd/hdl/blink_bd_wrapper.v
    Generated top-level HDL wrapper.

P1_Blink.runs/impl_1/blink_bd_wrapper.bit
    Generated bitstream from the checked-in implementation run.
```

## RTL Behavior

`blink.v` has one clock input and two 3-bit RGB outputs:

```verilog
module blink #(
    parameter CLK_FREQ_HZ = 100_000_000
)(
    input wire clk,
    output reg [2:0] rgb_led0,
    output reg [2:0] rgb_led1
);
```

The counter runs for `CLK_FREQ_HZ` cycles, then increments a 3-bit state. With a
100 MHz PL clock, this changes state once per second.

The output sequence is:

```text
000 -> 001 -> 010 -> 011 -> 100 -> 101 -> 110 -> 111 -> repeat
```

Both RGB LEDs show the same value.

## LED Bit Mapping

The RTL uses this bit order:

```text
rgb_ledX[2] = red
rgb_ledX[1] = green
rgb_ledX[0] = blue
```

The XDC maps the top-level ports to the ZUBoard RGB LEDs:

```text
rgb_led0_0[2] -> A7 -> LED0 red
rgb_led0_0[1] -> B6 -> LED0 green
rgb_led0_0[0] -> B5 -> LED0 blue

rgb_led1_0[2] -> B4 -> LED1 red
rgb_led1_0[1] -> A2 -> LED1 green
rgb_led1_0[0] -> F4 -> LED1 blue
```

All six LED pins use `LVCMOS18`.

## How `blink.v` Enters the Block Design

`blink.v` was added to Vivado as a design source, then inserted into the block
diagram as an HDL module reference. Vivado generated an IP-integrator wrapper
around it named like `blink_bd_blink_0_0`.

In the generated block-design HDL, the connection is:

```verilog
blink_bd_blink_0_0 blink_0
     (.clk(zynq_ultra_ps_e_0_pl_clk0),
      .rgb_led0(blink_0_rgb_led0),
      .rgb_led1(blink_0_rgb_led1));
```

So this is not a manually written top-level instantiation. Vivado's block design
owns the top-level structure.

## Simulation

The testbench instantiates `blink` directly and overrides the clock frequency:

```verilog
blink #(.CLK_FREQ_HZ(10)) uut (...);
```

That makes simulation fast. With a 100 MHz simulated clock, the LED state
changes every 10 cycles instead of every 100 million cycles.

Run from Vivado:

```text
Flow Navigator -> Simulation -> Run Simulation -> Run Behavioral Simulation
```

The checked-in simulation log shows the expected sequence:

```text
000, 001, 010, 011, 100, 101, 110, 111, repeat
```

## Build Flow

Open the project:

```text
Vivado -> Open Project -> P1_Blink.xpr
```

Then:

```text
Open Block Design
Validate Design
Generate Output Products if needed
Create HDL Wrapper if needed
Run Synthesis
Run Implementation
Generate Bitstream
```

The current implementation completed successfully:

- DRC: 0 violations
- Timing: met
- Bitstream: `P1_Blink.runs/impl_1/blink_bd_wrapper.bit`

## Programming the Board

Use USB/JTAG, not Ethernet:

```text
Open Hardware Manager
Open Target
Auto Connect
Program Device
Select P1_Blink.runs/impl_1/blink_bd_wrapper.bit
```

Seeing `localhost` in Hardware Manager only means Vivado has connected to the
local `hw_server`. The actual device must also appear in the JTAG chain before
programming can work.

## Common Gotchas

- `localhost` connected does not mean the board is detected. Check that an
  `xczu1cg...` device appears under the hardware target.
- Use the ZUBoard USB/JTAG connection for programming.
- If Vivado cannot see the board on Linux, check cable drivers and udev rules.
- If the LEDs do not change, confirm the bitstream was programmed and that the
  XDC port names still match the generated wrapper.
- The project depends on the PS block for `pl_clk0`; the PL blink logic does not
  use software running on the ARM cores.
