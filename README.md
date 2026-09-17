# SuperMetroidDS

Nintendo DS port of the Super Metroid static recompilation ([SuperMetroidRecomp](https://github.com/mstan/SuperMetroidRecomp)), built with devkitARM and libnds.

## Overview

This project ports the LLE-first recompiled C codebase of Super Metroid to run natively on Nintendo DS hardware (ARM9/ARM7 dual CPU, 4MB RAM, dual screens). The recompiled 65816 CPU code runs directly on ARM9; only the SNES PPU, APU, DMA, and HDMA are emulated.

## Status

- ✅ Build pipeline (devkitARM + Docker + GitHub Actions)
- ✅ Minimal ARM9/ARM7 entry points with VBlank loop
- 🚧 Sprint 1: Foundation & Build System (T002: Submodules in progress)
- 📋 Sprint 2+: CPU runtime, Video, Audio, Input, Save

## Requirements

- Docker (for containerized builds)
- OR devkitPro (devkitARM, libnds, calico, maxmod, fatfs) installed locally
- melonDS / DeSmuME / NO$GBA for testing
- Super Metroid (Japan, USA) 1.0 ROM (`.sfc`) — **not included**

## Quick Start (Docker)

```bash
# Build the .nds ROM
./build.sh

# Output: build/SuperMetroidDS.nds
```

## Quick Start (Local devkitARM)

```bash
# Verify installation
make setup

# Build
make

# Output: build/SuperMetroidDS.nds
```

## Project Structure

```
src/
├── main.c           # ARM9 entry point
├── arm7/
│   └── main.c       # ARM7 entry point
assets/
├── banner.bin       # NDS banner (placeholder)
docs/
├── VISION.md        # Problem, solution, value
├── REQUIREMENTS.md  # Functional & non-functional requirements
├── ROADMAP.md       # Sprint backlog with Impact/Effort
├── PERSONAS.md      # User & maintainer profiles
├── DESIGN.md        # DS hardware spec (memory map, video, audio)
├── QUALITY_GATES.md # Quality gate configuration
└── CHECKLIST.md     # Pre-commit / pre-release checks
```

## Building for Hardware

1. Copy `build/SuperMetroidDS.nds` to your flashcart (R4, EZ-Flash, etc.)
2. Place a legal Super Metroid (Japan, USA) 1.0 `.sfc` ROM on the SD card
3. Launch from flashcart menu

## Development

### AES Protocol

This project follows the [Ambrósio Engineering System (AES)](https://github.com/ambrosio-engineering/aes) for all non-trivial changes:

- Hostile Analysis before implementation
- Surgical changes only
- Diffstory with every commit
- Quality gates: build, lint, test

### CI/CD

GitHub Actions runs on every push:
- Build in `devkitpro/devkitarm` container
- Lint with `cppcheck`
- Format check with `clang-format`
- Artifacts uploaded (`.nds`, `.elf`, `.map`)

## License

PolyForm Noncommercial 1.0.0 (inherited from SuperMetroidRecomp)

The game ROM and any data extracted from it are **not** in this repo and are not licensed for redistribution.

## References

- [SuperMetroidRecomp](https://github.com/mstan/SuperMetroidRecomp) — Source recompilation
- [snesrecomp](https://github.com/mstan/snesrecomp) — Recompilation framework
- [devkitPro](https://devkitpro.org/) — Toolchain
- [libnds](https://github.com/devkitPro/libnds) — Nintendo DS library
- [Calico](https://github.com/devkitPro/calico) — Modern libnds replacement