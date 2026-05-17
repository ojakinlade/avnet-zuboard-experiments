# P2_PS_PL_RGB

`P2_PS_PL_RGB` is the second ZUBoard project in this repo. It is the first
simple PS/PL project: software running on the Zynq UltraScale+ PS selects RGB
LED colors, while a PL AXI GPIO peripheral drives the physical LED pins.

This project is the bridge between the pure PL blink project and larger
hardware/software co-design work. It proves the pattern that will be reused
later for custom accelerators:

```text
PS software writes registers over AXI
        |
        v
PL hardware observes those register values
        |
        v
Board-level behavior changes
```

## Hardware Target

- Board: Avnet ZUBoard 1CG
- Device: `xczu1cg-sbva484-1-e`
- Vivado/Vitis version used for this project: `2024.2`
- PS processor used by the app: `psu_cortexa53_0`
- Software domain: `standalone`
- Architecture: 64-bit AArch64

## Project Structure

```text
P2_PS_PL_RGB.xpr
    Vivado project file.

P2_PS_PL_RGB.srcs/sources_1/bd/rgb_bd/rgb_bd.bd
    Vivado block design.

P2_PS_PL_RGB.gen/sources_1/bd/rgb_bd/hdl/rgb_bd_wrapper.v
    Generated top-level HDL wrapper.

P2_PS_PL_RGB.runs/impl_1/rgb_bd_wrapper.bit
    Generated PL bitstream.

rgb_bd_wrapper.xsa
    Exported hardware platform from Vivado, including the bitstream.

vitis/
    Vitis Unified IDE workspace.

vitis/ps_pl_rgb_platform/
    Vitis platform component created from the XSA.

vitis/rgb_control_app/
    Bare-metal application component.

vitis/rgb_control_app/src/main.c
    PS-side C program that cycles RGB LED colors.
```

## Hardware Design

The Vivado block design is named `rgb_bd`.

It contains:

- `zynq_ultra_ps_e_0`: Zynq UltraScale+ MPSoC processing system.
- `axi_smc`: SmartConnect inserted by Vivado for AXI routing.
- `rst_ps8_0_100M`: Processor System Reset block.
- `gpio_io_o`: AXI GPIO peripheral configured as a 6-bit output.

The high-level connection is:

```text
Zynq PS M_AXI_HPM0_FPD
        |
        v
AXI SmartConnect
        |
        v
AXI GPIO, base address 0xA0000000
        |
        v
gpio_io_o_0[5:0]
        |
        v
ZUBoard RGB LED pins
```

`SmartConnect` and `Processor System Reset` are expected. Vivado adds them so
the PS AXI master can talk cleanly to the AXI GPIO slave in the PL clock/reset
domain.

## AXI GPIO Configuration

Only GPIO channel 1 is used.

```text
GPIO Width: 6
Direction: all outputs
GPIO 2 / dual channel: disabled
```

The AXI GPIO peripheral is memory-mapped into the PS address space:

```text
Base address: 0xA0000000
High address: 0xA000FFFF
```

In the Vitis app, the generated SDT-style macro is:

```c
#define GPIO_BASEADDR XPAR_XGPIO_0_BASEADDR
```

This base address is passed to:

```c
XGpio_Initialize(&gpio, GPIO_BASEADDR);
```

In this Vitis flow, `XGpio_Initialize()` expects the base address, not the old
integer device ID style used by some older BSP examples.

## LED Bit Mapping

The external block-design port is:

```text
gpio_io_o_0[5:0]
```

The project uses RGB order per LED:

```text
gpio_io_o_0[0] = LED0 red
gpio_io_o_0[1] = LED0 green
gpio_io_o_0[2] = LED0 blue

gpio_io_o_0[3] = LED1 red
gpio_io_o_0[4] = LED1 green
gpio_io_o_0[5] = LED1 blue
```

The matching C definitions are:

```c
#define LED0_R (1U << 0)
#define LED0_G (1U << 1)
#define LED0_B (1U << 2)

#define LED1_R (1U << 3)
#define LED1_G (1U << 4)
#define LED1_B (1U << 5)
```

Useful values:

```text
LED0_R | LED1_R = both red
LED0_G | LED1_G = both green
LED0_B | LED1_B = both blue
all bits set     = both white
0x00             = both off
```

## Pin Mapping

The LED pins are constrained to the same physical pins used in `P1_Blink`:

```text
gpio_io_o_0[0] -> A7 -> LED0 red
gpio_io_o_0[1] -> B6 -> LED0 green
gpio_io_o_0[2] -> B5 -> LED0 blue

gpio_io_o_0[3] -> B4 -> LED1 red
gpio_io_o_0[4] -> A2 -> LED1 green
gpio_io_o_0[5] -> F4 -> LED1 blue
```

All six LED signals use `LVCMOS18`.

## Vivado Flow

Open the project:

```text
Vivado -> Open Project -> P2_PS_PL_RGB.xpr
```

The core build flow is:

```text
Open Block Design
Validate Design
Generate HDL Wrapper
Run Synthesis
Run Implementation
Generate Bitstream
File -> Export -> Export Hardware
Include bitstream
```

The exported hardware file is:

```text
rgb_bd_wrapper.xsa
```

The latest checked-in implementation completed successfully:

- DRC: 0 errors
- Critical warnings: 0
- Bitstream: `P2_PS_PL_RGB.runs/impl_1/rgb_bd_wrapper.bit`

## Vitis Flow

The Vitis Unified IDE workspace lives in:

```text
vitis/
```

Components:

```text
ps_pl_rgb_platform
    Platform component created from rgb_bd_wrapper.xsa.

rgb_control_app
    Application component targeting standalone_psu_cortexa53_0.
```

The app source is:

```text
vitis/rgb_control_app/src/main.c
```

The app:

1. Prints a startup message over UART with `xil_printf`.
2. Initializes AXI GPIO at `XPAR_XGPIO_0_BASEADDR`.
3. Sets GPIO channel 1 as output.
4. Loops forever through color combinations on both RGB LEDs.

## Running on Hardware

Connect the ZUBoard over USB/JTAG, then in Vitis:

```text
Build platform component if the XSA changed
Build rgb_control_app
Run or Debug on Hardware
```

The hardware launch must do two things:

```text
Program the PL bitstream
Download and start the PS ELF on psu_cortexa53_0
```

Programming the bitstream alone is not enough. The LED colors only cycle after
the PS application is downloaded and running.

Open a serial terminal to the ZUBoard UART at:

```text
115200 baud, 8-N-1
```

Expected startup text:

```text
PS/PL RGB LED demo starting...
```

## Run vs Debug Notes

If Vitis is set up for bare-metal debug, launching may halt at `main()` until
you press Resume/Continue. For a normal run, the launch configuration should:

- target `psu_cortexa53_0`
- program the FPGA if needed
- run `psu_init`
- download the ELF
- start or resume the CPU after download

If the LEDs only move after using Debug, check whether the Run configuration is
only programming the PL or is stopping at `main()`.

## DDR, OCM, and Linker Notes

The normal place to run this app is DDR. Vitis downloads the ELF into DDR, then
the A53 executes code from DDR.

OCM can be useful as a temporary debug target for tiny programs, but both OCM
and DDR are volatile. Neither stores the app permanently across power cycles.

For standalone boot without Vitis/JTAG, a later project would need a boot image
containing the FSBL, bitstream, and application ELF, then place it on SD card or
QSPI flash.

## Common Gotchas

- `UCIO-1` at bitstream time means the external GPIO pins are not constrained.
  Make sure all six `gpio_io_o_0[*]` bits have package pins and `LVCMOS18`.
- If the GPIO width shows `1`, delete the existing external GPIO port, set AXI
  GPIO width to `6`, then make the GPIO output external again.
- The AXI GPIO should be output-only for this project. Do not enable all inputs.
- `GPIO` and `GPIO 2` in the AXI GPIO customization dialog are channel 1 and
  channel 2. This project only uses channel 1.
- `Memory write error at 0x0. EDITR not ready` usually means the debug target is
  wedged or the A53 was not initialized/reset cleanly. Power-cycle, reconnect,
  rebuild if needed, and make sure `psu_init` runs before ELF download.
- If DDR suddenly fails after previously working, rebuild the platform/app and
  check that the linker script still maps sections to DDR correctly.

