# Personas

## User: DS Homebrew Player

**Profile:** Owns a Nintendo DS/DSi/3DS with flashcart (R4, EZ-Flash, etc.) or plays on emulator (melonDS, DeSmuME). Wants to play Super Metroid faithfully on DS hardware. Values accuracy, performance, and authentic feel.

**Goals:**
- Play Super Metroid at 60 FPS on real DS hardware
- Authentic SNES gameplay — no mods, widescreen, or enhancements
- Save/load works reliably on flashcart/SD
- Simple launch: copy `.nds` + ROM to SD, run

**Pain Points:**
- Existing SNES emulators on DS are slow/inaccurate for Super Metroid
- Complex setup (per-game config, BIOS files, etc.)
- Save corruption or incompatibility between emulators

---

## User: Preservation Enthusiast

**Profile:** Interested in static recompilation as a preservation technique. Wants to see snesrecomp work on a constrained embedded platform (DS) as a proof of concept.

**Goals:**
- Verify LLE-first recompilation runs on ARM9 without host OS
- Study memory/performance characteristics on 4MB RAM target
- Reference implementation for future recompilation ports (GBA, other consoles)

**Pain Points:**
- Lack of documented recompilation ports to bare-metal/embedded
- PC-centric build assumptions in snesrecomp framework

---

## Maintainer

**Profile:** Engineer maintaining this port long-term. Familiar with C, ARM, devkitPro, SNES architecture.

**Goals:**
- Keep port in sync with upstream SuperMetroidRecomp/snesrecomp
- Maintain deterministic regeneration pipeline
- Ensure build reproducibility across devkitARM versions
- Document DS-specific adaptations for future porters

**Tools:**
- AES (Ambrósio Engineering System) for all changes
- `make check` for validation (build, lint, test on emulator)
- devkitPro toolchain, melonDS for CI testing