# 5-Stage Pipelined RISC-V Processor with Hazard Detection & Forwarding

A fully operational, structurally pipelined 32-bit RISC-V processor core designed and verified using Xilinx Vivado. The architecture features hardware acceleration for handling data hazards seamlessly without sacrificing cycle throughput.

## Core Architectural Features

* **5-Stage Classical Pipeline Layout:** Split into standard Instruction Fetch (IF), Instruction Decode (ID), Execution (EX), Memory Access (MEM), and Write-Back (WB) stages.

* **Dynamic Forwarding Unit:** Actively detects structural data dependencies and routes computational results straight from the EX/MEM and MEM/WB stage registers back into the ALU inputs, eliminating RAW stalls for arithmetic sequences.

* **Hazard Detection Unit:** Automatically identifies immediate Load-Use hazards, dynamically dropping `PCWrite` and `IF_ID_Write` control lines to freeze preceding instructions while injecting an execution "bubble" (NOP) to preserve state stability.

* **Modular Processing Components:** Includes a universal parameterizable 2-to-1 Multiplexer, Register File with dual combinational read paths, Data Memory, Control Unit, and custom Immediate Generator.

## Hardware Verification & Waveforms

The design has been validated through behavioral simulation via testbenches targeting explicit arithmetic dependency chains and load-use hazard boundaries.

### 1. Steady-State Pipeline Execution

During consecutive R-type and I-type operation blocks, instructions stream diagonally across the tracking lanes. The Forwarding Unit dynamically switches routing states to maintain a single-cycle execution path without requiring pipeline bubbles.

### 2. Load-Use Hazard Stall Injection

When a dependency immediately follows a memory load instruction (`lw`), the Hazard Detection Unit safely intercepts execution. It holds the Program Counter, freezes the decode registers, and injects a single-cycle NOP bubble into the execution stage until data memory access completes.