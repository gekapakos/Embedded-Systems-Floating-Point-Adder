# Project Overview

## FPGA Design of a Floating Point Unit (FPU)
- **Description**: A hardware design project implementing a Floating Point Adder (FPA) in Verilog on a Xilinx Zynq-7000 FPGA (Zedboard) using Vivado. Covers simulation, synthesis, and real-time testing.
- **Course**: ECE 340 - Embedded Systems, Spring 2024.
- **Purpose**: Introduces Verilog HDL, FPGA design flow, and Zedboard functionality for a single-precision FPA per IEEE 754-1985.
- **Platform**: Zedboard with Zynq-7000 FPGA, 512 MB DDR3, Vivado 2020.2 toolset.

## Step Descriptions

### Step 1: Design and Behavioral Simulation of Single Cycle FP Adder
- **Description**: Design a single-cycle FPA in Verilog (`fpadd_single.v`) with registered I/O, simulate using a testbench, and debug via Vivado. Implements IEEE 754 addition, handles zero output, and counts leading zeros for normalization. Verified with provided `.hex` test file.

### Step 2: Design and Behavioral Simulation of a Pipelined FP Adder
- **Description**: Extend Step 1 into a 2-stage pipelined FPA, balancing computation (~50% per stage). Simulate behaviorally in Vivado, analyze RTL schematics via elaboration to optimize clock period and performance.

### Step 3: FP Adder in FPGA with 7-Segment Display Output
- **Description**: Implement the 2-stage FPA on Zedboard, displaying 16-bit results on two 7-segment displays (via PMOD) and 8 LEDs. Code `SevenSegDisplay` module with 320ns multiplexing. Hardwire inputs, synthesize, and route using `fpadd_system.v` and constraints (`fp_add.xdc`).

### Step 4: Use Buttons to Provide Multiple Inputs to the FP Adder
- **Description**: Add a `DataMemory.v` (64xNUM bits) for dynamic inputs from a `.hex` file, triggered by a button press. Include an FSM-based edge detector (`L2P`) and debouncer (0.1s stability) to filter button noise. Outputs updated on 7-segment displays and LEDs.

## Design Flow
- **Tools Setup**: Source Vivado scripts (`settings64.sh`) in Linux.
- **Simulation**: Behavioral and post-implementation timing via Vivado simulator.
- **Synthesis**: Generate gate-level netlist from Verilog.
- **Implementation**: Translate, map, place, and route to FPGA bitstream.
- **Bitstream**: Generate `.bit` file and program Zedboard via JTAG.

## Key Features
- **FPA**: Single-precision, IEEE 754 compliant, no overflow/underflow checks.
- **I/O**: LEDs, 7-segment displays, button inputs with debouncing.
- **Constraints**: 10ns clock (100 MHz), LVCMOS33 I/O standard, pin assignments via XDC.
