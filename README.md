# MIPS Wordle

A Wordle-style game implemented in MIPS assembly and designed to run with the MARS MIPS simulator.

## Requirements

Before running the project, make sure you have:

- **Java** installed and available on your system.
- **MARS (MIPS Assembler and Runtime Simulator)** installed/downloaded. MARS is an IDE for MIPS assembly language programming. [Download MARS](https://dpetersanderson.github.io/)
- This repository cloned/downloaded in its entirety.

> **Important:** MARS must be run from the repository's directory. `wordle.asm` is structurally dependent on other files in the project, so do not move `wordle.asm` or run MARS from a different directory.

## Running the Game

Follow these steps exactly.

### 1. Start MARS

Open **MARS** from the repository directory.

MARS needs to run in the **same directory as `wordle.asm`** because `wordle.asm` is structurally dependent on other project files.

### 2. Open `wordle.asm`

In MARS, open:

```text
wordle.asm
```

### 3. Open the Bitmap Display

From the MARS menu, select:

**Tools → Bitmap Display**

Configure the Bitmap Display with the following settings:

| Setting | Value |
|---|---|
| Pixel width | `4` |
| Pixel height | `4` |
| Display width | `256` |
| Display height | `512` |
| Base address for display | `0x10000000` |

The base address corresponds to the **global data** address.

### 4. Open the Keyboard and Display MMIO Simulator

From the MARS menu, select:

**Tools → Keyboard and Display MMIO Simulator**

### 5. Connect the MARS Tools

Connect both:

- **Bitmap Display**
- **Keyboard and Display MMIO Simulator**

to **MIPS**.

### 6. Assemble the Program

Assemble `wordle.asm` by clicking the **wrench/screwdriver (Assemble)** icon in MARS.

Make sure the assembly completes successfully before continuing.

### 7. Run the Program

Click the **play (Run)** icon to execute the assembled program.

### 8. Focus the Keyboard Input

Click inside the **bottom field** of the **Keyboard and Display MMIO Simulator**.

This gives the simulator keyboard focus so that your keystrokes are sent to the game.

### 9. Play!

You're ready to play Wordle.

Have fun!

## Troubleshooting

### The program cannot find another file

Make sure MARS is running from the **same directory as `wordle.asm`** and that the repository's file structure has not been changed.

### The display does not look correct

Double-check the Bitmap Display settings:

- Pixel width: `4`
- Pixel height: `4`
- Display width: `256`
- Display height: `512`
- Base address: `0x10000000`

Also make sure the Bitmap Display is connected to MIPS.

### Keyboard input does not work

Click inside the **bottom field** of the Keyboard and Display MMIO Simulator and make sure the simulator is connected to MIPS.

## MARS

MARS (MIPS Assembler and Runtime Simulator) is an educational IDE for MIPS assembly language programming.

Official MARS website: https://dpetersanderson.github.io/
