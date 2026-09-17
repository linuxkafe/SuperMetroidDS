# Requirements

## Functional

- Boot Super Metroid (Japan, USA) 1.0 ROM on Nintendo DS (real hardware and emulators: melonDS, DeSmuME, NO$GBA)
- Run the recompiled 65816 CPU code natively on ARM9 via LLE-first model
- Render PPU output to DS dual screens (main: gameplay, sub: minimap/HUD or both gameplay)
- Play audio via SPC700 → DS audio (ARM7 mixer: PSG channels + PCM samples)
- Handle input: DS keypad (D-pad, A/B/X/Y/L/R/Start/Select) mapped to SNES controller
- Save/load SRAM to DS cartridge save memory or SD card (fatfs)
- Support the deterministic regeneration pipeline (`tools/regen.sh --strict-idempotent`)
- Produce a clean `.nds` ROM via devkitARM toolchain

## Non-Functional

- **Performance**: 60 FPS sustained on DS hardware (ARM9 @ 67 MHz, ARM7 @ 33 MHz)
- **Memory**: Fit within 4MB main RAM + 64KB VRAM (main) + 64KB VRAM (sub) + 128KB ARM7 WRAM
- **Binary size**: Target ≤ 4MB ARM9 binary + ≤ 256KB ARM7 binary
- **Build reproducibility**: Deterministic builds from same source + regen.sh output
- **No dynamic allocation** in hot paths (frame loop, NMI, IRQ, HDMA handlers)
- **Portability**: Build on Linux/macOS/Windows with devkitPro installed

## Constraints

- Language: C (C11), ARM assembly where necessary
- Toolchain: devkitARM (GCC for ARM), libnds, maxmod (audio), fatfs (filesystem)
- Build system: CMake (primary) + Makefile (fallback), targeting `.nds`
- Dependencies: SuperMetroidRecomp source (submodule or vendored), snesrecomp framework (submodule)
- ROM: User supplies legal Super Metroid (Japan, USA) 1.0 `.sfc` — not redistributed
- Generated code: `src/gen/` produced locally via `tools/regen.sh`, never committed
- Hardware: Nintendo DS (phat/lite), DSi (DS mode), 3DS (TWL mode), DS emulators