---
ticket: T001
title: Initialize devkitARM CMake/Makefile, produce minimal .nds
sprint: sprint-01
priority: high
status: done
created: 2026-09-17
completed: 2026-09-17
---

# T001 — Initialize devkitARM CMake/Makefile, produce minimal .nds

## Context
The project needs a working build system targeting Nintendo DS (devkitARM) that produces a valid `.nds` ROM. This is the foundation for all subsequent work.

## Acceptance Criteria
- [x] `make setup` verifies devkitARM installation
- [x] `make build` compiles without errors and produces `build/SuperMetroidDS.nds`
- [x] `ndstool -i build/SuperMetroidDS.nds` shows valid ARM9/ARM7 binaries and header
- [x] `make lint` runs cppcheck on source files
- [x] `make check` passes (docs-check + build + lint)
- [x] Docker build pipeline works (`./build.sh`)

## Validation Results
```
$ ./build.sh
🚀 Building SuperMetroidDS (Nintendo DS Port)...
Linking ARM9: SuperMetroidDS.arm9.elf
Linking ARM7: SuperMetroidDS.arm7.elf
Packaging NDS: SuperMetroidDS.nds
✅ BUILD SUCCESS! SuperMetroidDS.nds created.

$ ls -la build/
SuperMetroidDS.arm9.elf  132KB
SuperMetroidDS.arm7.elf  73KB
SuperMetroidDS.nds       46KB

$ ndstool -i build/SuperMetroidDS.nds
Header information:
  ARM9 entry: 0x2004800, ARM7 entry: 0x2380000
  Logo CRC: 0xCF56 (OK)
  Header CRC: 0xE4F9 (OK)
```

## Scope
**In scope (completed):**
- Minimal `src/main.c` with ARM9 entry point (`main()`)
- Minimal `src/arm7/main.c` with ARM7 entry point
- Banner asset (`assets/banner.bin`) for ndstool (placeholder)
- Makefile with proper devkitARM/Calico flags
- Docker build script (`build.sh`) and Dockerfile
- GitHub Actions CI workflow

**Out of scope:**
- Any Super Metroid game logic
- PPU, APU, input, save systems
- Submodule integration (T002)
- Memory pool/arena implementation (T003)

## Technical Decisions
- Used Calico (modern libnds replacement) via devkitpro/devkitarm Docker image
- ARM9: `-specs=calico/share/ds9.specs` + `-lcalico_ds9` + `-lnds9`
- ARM7: `-specs=calico/share/ds7.specs` + `-lcalico_ds7` + `-lnds7`
- Platform defines: `ARM9`/`ARM7` + `__NDS__` for Calico detection
- C standard: `gnu11` (allows `asm` keyword in Calico headers)
- Single-phase Makefile (simpler than ds_rules two-phase)

## Known Risks (Documented)
- Banner CRC invalid (zero-filled placeholder) — needs proper banner generation
- ARM7/ARM9 sync via FIFO/IPC not yet implemented — minimal stubs only
- melonDS test not run in CI (no GUI/headless support in container) — manual test only

## Next Steps
- T002: Submodule structure for SuperMetroidRecomp + snesrecomp
- T003: Port memory map: define ARM9/ARM7 memory regions, pools, arenas
- T004: Implement minimal ARM9 entry point + VBlank handler