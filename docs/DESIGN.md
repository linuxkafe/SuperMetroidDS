# Design — Nintendo DS Hardware Specification

## Memory Map (ARM9)

| Region | Size | Purpose |
|--------|------|---------|
| Main RAM (EWARM) | 4 MB | Recompiled banks, runtime, heap pools, frame buffers |
| VRAM A (Main BG) | 128 KB | Main screen backgrounds, textures |
| VRAM B (Main OBJ) | 128 KB | Main screen sprites/OBJ |
| VRAM C (Sub BG) | 128 KB | Sub screen backgrounds |
| VRAM D (Sub OBJ) | 128 KB | Sub screen sprites |
| VRAM E (Palettes) | 64 KB | BG/OBJ palettes (both screens) |
| VRAM F (Extended) | 16 KB | Overflow / Mode 7 texture cache |
| VRAM G (Extended) | 16 KB | Overflow |
| VRAM H (Extended) | 32 KB | Overflow |
| VRAM I (LCD) | 64 KB | Direct LCD access / frame capture |
| ARM9 BIOS | 32 KB | Boot, SWI handlers (read-only) |
| ARM9 ITCM | 32 KB | Critical hot code (NMI, IRQ, fiber switch) |
| ARM9 DTCM | 16 KB | Critical hot data (CPU regs, frame state) |

## Memory Map (ARM7)

| Region | Size | Purpose |
|--------|------|---------|
| ARM7 WRAM | 128 KB | Audio mixer (maxmod), IPC, WiFi, touch |
| ARM7 BIOS | 16 KB | Boot, SWI handlers |

## Pool/Arena Strategy

- **Bank Pool**: Static allocation for each recompiled bank (known sizes from regen.sh)
- **Frame Arena**: Per-frame scratch (PPU buffers, DMA lists) — reset each VBlank
- **Audio Arena**: ARM7-owned, double-buffered sample buffers
- **Save Arena**: SRAM buffer (8 KB max for Super Metroid)
- **No malloc/free** in NMI, IRQ, HDMA, or frame loop

## Video Architecture

- **Main Screen (256×192)**: Gameplay via BG layers (BG0=main, BG1=sub, BG2=HUD, BG3=Mode 7)
- **Sub Screen (256×192)**: Minimap + HUD (energy, reserves, ammo, map)
- **Mode 7**: SNES Mode 7 → DS BG3 affine + HDMA per-scanline params
- **Palettes**: 15-bit BGR (SNES) → 15-bit BGR (DS), direct mapping
- **VRAM Management**: Double-buffered BG maps, DMA copy during VBlank

## Audio Architecture

- **ARM7 (maxmod)**: 16 channels — 8 PSG (square/noise) + 8 PCM (samples)
- **SPC700 → DS**: Intercept SPC uploads in `sm_spc_player.c`, translate to maxmod commands via FIFO/IPC
- **Sample Rate**: SNES 32 kHz → DS 32 kHz (native) or 48 kHz (maxmod default)
- **Sync**: VBlank-driven audio frame (≈16.67 ms)

## Input Mapping

| DS Key | SNES Button |
|--------|-------------|
| D-Pad | D-Pad |
| A | B (confirm/fire) |
| B | A (cancel/jump) |
| X | X (dash) |
| Y | Y (item select) |
| L | L (aim up) |
| R | R (aim down) |
| Start | Start |
| Select | Select |

## Build Configuration

- **Toolchain**: devkitARM (arm-none-eabi-gcc), libnds, maxmod, fatfs
- **C Standard**: C11 (`-std=c11 -ffreestanding`)
- **Optimization**: `-O2 -fno-tree-vectorize` (size/speed balance)
- **Sections**: `.itcm` (ITCM), `.dtcm` (DTCM), `.rwarm` (main RAM)
- **Linker Script**: Custom `ds.ld` defining memory regions above

## Regeneration Pipeline

- `tools/regen.sh --strict-idempotent` runs on host (x86_64) — produces `src/gen/`
- Generated C is **platform-agnostic** (pure 65816 recompilation)
- DS build consumes `src/gen/` + hand-written DS runtime
- `recomp/*.cfg` never modified without full regeneration