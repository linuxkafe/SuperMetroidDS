---
sprint: sprint-01
period: 2026-09-17 → 2026-09-24
status: active
---

# Sprint 1 — Foundation & Build System

## Goal
Establish a working devkitARM build pipeline that produces a valid `.nds` ROM, with submodules for SuperMetroidRecomp and snesrecomp, and a defined memory map for ARM9/ARM7.

## Tickets
| ID | Title | Status |
|----|-------|--------|
| T001 | Initialize devkitARM CMake/Makefile, produce minimal `.nds` | **done** |
| T002 | Set up submodule structure for SuperMetroidRecomp + snesrecomp | in-progress |
| T003 | Port memory map: define ARM9/ARM7 memory regions, pools, arenas | pending |
| T004 | Implement minimal ARM9 entry point + VBlank handler | pending |

## T001 Validation Summary
- ✅ `make setup` / `./build.sh` — Docker build works
- ✅ `make build` / `./build.sh` — Produces valid `.nds` ROM
- ✅ `ndstool -i` — Valid ARM9/ARM7 headers, Logo CRC OK, Header CRC OK
- ✅ `make lint` — cppcheck runs (no issues in minimal code)
- ✅ `make check` — Full validation passes
- ✅ GitHub Actions CI — Configured with devkitARM container

## Retrospective
*Filled at end of sprint.*

### What went well
- Docker-based build eliminates host devkitARM installation issues
- Calico-based toolchain works with proper platform defines (`ARM9`, `ARM7`, `__NDS__`)
- Single-phase Makefile simpler than ds_rules two-phase approach
- GitHub Actions CI ready for automated validation

### What went wrong
- Initial ds_rules two-phase Makefile conflicted with custom ARM9/ARM7 rules
- Calico platform detection required specific defines (`ARM9`/`ARM7` + `__NDS__`)
- C11 standard disabled GCC `asm` extension needed by Calico headers (fixed with gnu11)
- ARM7 specs file is `ds7.specs` in Calico, not `ds_arm7.specs`
- ndstool banner requires `-t` for binary, not `-b` (which expects BMP)

### What to change next sprint
- Create proper banner with `grit` tool for valid banner CRC
- Add submodule integration for SuperMetroidRecomp + snesrecomp
- Define memory map before integrating recompiled banks