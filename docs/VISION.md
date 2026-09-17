# Vision

## Problem

The Super Metroid static recompilation (SuperMetroidRecomp) runs on PC platforms (Windows, Linux, macOS, Android) using SDL/OpenGL. There is no Nintendo DS port. The DS hardware (dual ARM CPUs, 4MB RAM, dual screens, no OS, no standard library) is fundamentally different from PC targets, requiring a complete host layer rewrite while preserving the recompiled game logic.

Nintendo DS homebrew players and preservation enthusiasts cannot experience this faithful recompilation on original hardware. Existing SNES emulators on DS (e.g., SNES9x DS) run via interpretation and struggle with full-speed Super Metroid due to the SNES's complex PPU/APU/DMA architecture. A static recompilation port would offer near-native performance by running the recompiled 65816 CPU code directly on ARM.

## Solution

Port the LLE-first recompiled C codebase to Nintendo DS using devkitPro (devkitARM) and libnds:

1. **Replace the host layer** — Remove all SDL, OpenGL, recomp-ui launcher, and desktop-specific code. Implement DS-specific equivalents: libnds video (BG layers, OBJ, Mode 7), audio (SPC700 → DS PSG/PCM), input (DS keypad/touch), and file I/O (fatfs/ndsfs).
2. **Adapt the runtime** — Modify `sm_rtl.c` single-fiber frame model for DS dual-CPU architecture (ARM9 main, ARM7 audio/coproc). Handle NMI/IRQ/HDMA on DS hardware timers and VBlank.
3. **Memory management** — Fit recompiled banks + runtime + assets into 4MB main RAM + 64KB VRAM per screen. Use static pools/arenas, no malloc in hot paths.
4. **Build system** — CMake/Makefile targeting devkitARM, producing `.nds` ROM.
5. **Regeneration pipeline** — Keep `tools/regen.sh` deterministic; generated `src/gen/` stays local (not committed).

The recompiled CPU logic (`src/gen/`, `recomp/*.cfg`) is **not modified** — it is the ground truth. Only the host shim and platform abstraction change.

## Value

- **Preservation**: Faithful Super Metroid on original DS hardware via static recompilation, not emulation
- **Performance**: Recompiled 65816 → ARM runs near-native; only PPU/APU/DMA emulated
- **Reference port**: Demonstrates snesrecomp framework portability to constrained embedded targets
- **Community**: DS homebrew gets a flagship title showcasing recompilation vs. interpretation