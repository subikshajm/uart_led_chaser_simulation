# UART-Controlled LED Chaser Simulation in MATLAB

This repository contains the source code and documentation for a UART-controlled LED chaser simulation developed in MATLAB. The project is a software-based emulation of a microcontroller-controlled LED strip, featuring state-machine logic, simulated register manipulation, and command-based control via a text interface.

##  Objective

To simulate UART-based LED control operations using MATLAB without relying on external hardware or microcontroller development kits. The system emulates GPIO register behavior, state transitions, and real-time command processing, replicating fundamental embedded system concepts.

##  Features

- UART-style command input (e.g., CHASE, BLINK, RECORD, REPLAY)
- 8-bit virtual GPIO register controlling simulated LEDs
- Finite State Machine (FSM) logic for clean execution flow
- Custom pattern recording and replay functionality
- MATLAB-only simulation: no additional toolboxes, no hardware dependencies
- Optional GUI visualization or console-based LED outputs

##  Modules Overview

- *Command Processor*: Parses and interprets UART-style commands.
- *State Machine*: Manages system states like Idle, Chase, Blink, Record, Replay, and Stop.
- *Register Logic*: Simulates GPIO control through 8-bit MATLAB arrays.
- *Timer Emulation*: Mimics embedded delay using pause() for real-time behavior.
- *Pattern Storage*: Temporarily stores user-defined LED sequences.
- *Output Renderer*: Displays the LED states via console or UI.

## Commands Supported

- CHASE: Sequential left-to-right LED activation.
- BLINK: Simultaneous on/off toggling of all LEDs.
- RECORD: Records a user-defined LED sequence.
- REPLAY: Replays the most recently recorded pattern.
- EDIT: Allows overwriting a recorded sequence.
- STOP: Terminates current action and resets to idle.

## Example Outputs

Refer to the figures/ folder or the IEEE report PDF for screenshots of the simulated LED patterns for each command.

## Use Case and Applications

This simulation is ideal for:

- Students learning embedded systems or serial communication.
- Developers prototyping embedded behavior before hardware deployment.
- Educational institutions for labs without microcontroller kits.

##  Requirements

- MATLAB R2020a or higher (basic version works fine)
- No toolboxes required
- Works on Windows/Linux/Mac

##  License

This project is provided for academic and educational use. Commercial use is prohibited without permission. All rights reserved.

---

*Developed by:* [Subiksha Jagadeesan Murugan]   
*Year:* 2025
