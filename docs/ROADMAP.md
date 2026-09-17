# Roadmap

## Sprint 1: Foundation & Build System [HIGH]

| ID | Task | Impact | Effort | Status |
|----|------|--------|--------|--------|
| T001 | Initialize devkitARM CMake/Makefile, produce minimal `.nds` | High | Medium | todo |
| T002 | Set up submodule structure for SuperMetroidRecomp + snesrecomp | High | Low | todo |
| T003 | Port memory map: define ARM9/ARM7 memory regions, pools, arenas | High | High | todo |
| T004 | Implement minimal ARM9 entry point + VBlank handler | High | Medium | todo |

## Sprint 2: CPU Runtime Port [HIGH]

| ID | Task | Impact | Effort | Status |
|----|------|--------|--------|--------|
| T005 | Port `sm_rtl.c`: single-fiber frame model to DS (ARM9 main loop) | High | High | todo |
| T006 | Port NMI/IRQ/HDMA handling to DS hardware timers + VBlank | High | High | todo |
| T007 | Port `sm_cpu_infra.c`: RtlGameInfo registration for DS | High | Medium | todo |
| T008 | Integrate recompiled banks (`src/gen/`) into DS build | High | Medium | todo |

## Sprint 3: Video Subsystem [HIGH]

| ID | Task | Impact | Effort | Status |
|----|------|--------|--------|--------|
| T009 | Implement PPU → DS BG/OBJ/Mode7 renderer (libnds) | High | High | todo |
| T010 | Dual-screen layout: main gameplay + sub minimap/HUD | High | Medium | todo |
| T011 | Palette management (SNES 15-bit → DS 15-bit) | Medium | Medium | todo |
| T012 | DMA-driven VRAM updates, double-buffering | High | Medium | todo |

## Sprint 4: Audio Subsystem [HIGH]

| ID | Task | Impact | Effort | Status |
|----|------|--------|--------|--------|
| T013 | Port `sm_spc_player.c`: SPC700 upload interception → ARM7 | High | High | todo |
| T014 | Implement ARM7 audio mixer (maxmod): PSG + PCM | High | High | todo |
| T015 | Audio sync with VBlank, sample rate conversion (32kHz → 48kHz/32kHz) | Medium | Medium | todo |

## Sprint 5: Input, Save, Polish [MEDIUM]

| ID | Task | Impact | Effort | Status |
|----|------|--------|--------|--------|
| T016 | Input mapping: DS keypad → SNES controller | Medium | Low | todo |
| T017 | SRAM save/load via fatfs (SD) or cartridge EEPROM | Medium | Medium | todo |
| T018 | Boot ROM selection menu (file browser) | Medium | Medium | todo |
| T019 | Optimization pass: profile, reduce RAM, improve frame time | Medium | High | todo |
| T020 | Regression testing: attract demo, new game, doors, save | High | Medium | todo |

## Backlog

- [DISCOVERED] ARM7/ARM9 IPC for audio commands
- [DISCOVERED] HDMA timing accuracy on DS timer hardware
- [DISCOVERED] Mode 7 rendering on DS 2D engine limitations
- [DISCOVERED] Generated code size vs. 4MB RAM constraint