---
project: SuperMetroidDS
created: 2026-09-17
current_sprint: sprint-01
current_ticket: T002
---

# Kanban — SuperMetroidDS

## Backlog
- T003: Port memory map: define ARM9/ARM7 memory regions, pools, arenas
- T004: Implement minimal ARM9 entry point + VBlank handler
- T005: Port `sm_rtl.c`: single-fiber frame model to DS (ARM9 main loop)
- T006: Port NMI/IRQ/HDMA handling to DS hardware timers + VBlank
- T007: Port `sm_cpu_infra.c`: RtlGameInfo registration for DS
- T008: Integrate recompiled banks (`src/gen/`) into DS build
- T009: Implement PPU → DS BG/OBJ/Mode7 renderer (libnds)
- T010: Dual-screen layout: main gameplay + sub minimap/HUD
- T011: Palette management (SNES 15-bit → DS 15-bit)
- T012: DMA-driven VRAM updates, double-buffering
- T013: Port `sm_spc_player.c`: SPC700 upload interception → ARM7
- T014: Implement ARM7 audio mixer (maxmod): PSG + PCM
- T015: Audio sync with VBlank, sample rate conversion
- T016: Input mapping: DS keypad → SNES controller
- T017: SRAM save/load via fatfs (SD) or cartridge EEPROM
- T018: Boot ROM selection menu (file browser)
- T019: Optimization pass: profile, reduce RAM, improve frame time
- T020: Regression testing: attract demo, new game, doors, save

## Sprint 1: Foundation & Build System
- T001: Initialize devkitARM CMake/Makefile, produce minimal `.nds` — **DONE**
- T002: Set up submodule structure for SuperMetroidRecomp + snesrecomp — **IN PROGRESS**

## Done
- T001: Initialize devkitARM CMake/Makefile, produce minimal `.nds`