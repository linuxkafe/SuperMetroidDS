---
ticket: T001
title: Initialize devkitARM CMake/Makefile, produce minimal .nds
sprint: sprint-01
priority: high
status: in-progress
created: 2026-09-17
---

# T001 — Initialize devkitARM CMake/Makefile, produce minimal .nds

## Context
The project needs a working build system targeting Nintendo DS (devkitARM) that produces a valid `.nds` ROM. This is the foundation for all subsequent work. The existing generic Makefile has been updated for devkitARM but needs validation and a minimal C entry point to prove the toolchain works.

## Acceptance Criteria
- [ ] `make setup` verifies devkitARM installation
- [ ] `make build` compiles without errors and produces `build/SuperMetroidDS.nds`
- [ ] `ndstool -h build/SuperMetroidDS.nds` shows valid ARM9/ARM7 binaries and banner
- [ ] `make test` runs on melonDS (headless) without crashing immediately
- [ ] `make lint` runs cppcheck on source files
- [ ] `make check` passes (docs-check + build + lint)

## Scope
**In scope:**
- Minimal `src/main.c` with ARM9 entry point (`main()`)
- Minimal `src/arm7/main.c` with ARM7 entry point
- Banner asset (`assets/banner.bin`) for ndstool
- Updated Makefile with proper devkitARM flags, memory sections
- `.gitignore` for build artifacts

**Out of scope:**
- Any Super Metroid game logic
- PPU, APU, input, save systems
- Submodule integration (T002)
- Memory pool/arena implementation (T003)

## Dependencies
- devkitPro (devkitARM, libnds, maxmod, fatfs) installed
- melonDS for testing (optional but recommended)

## Rollback
If build system fails: revert Makefile and src/ to empty state, re-scaffold.

## Known Risks
- devkitARM path varies by OS/install method (handled via `DEVKITARM` env var)
- ndstool banner format must be correct (16-color 256×192 bitmap + palette)
- ARM7/ARM9 sync via FIFO/IPC not yet implemented — minimal stubs only

## Notes
- Use `-specs=ds_arm9.specs` and `-specs=ds_arm7.specs` for correct crt0
- ARM9 code in `src/`, ARM7 code in `src/arm7/`
- Banner can be generated from a PNG using `grit` (devkitPro tool)
- Start with minimal `while(1) swiWaitForVBlank();` loops on both CPUs