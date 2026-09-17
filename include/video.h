#ifndef SUPERMETROIDDS_VIDEO_H
#define SUPERMETROIDDS_VIDEO_H

#include <nds.h>

#ifdef __cplusplus
extern "C" {
#endif

// Video subsystem initialization
void videoInit(void);

// VBlank handler for dual-screen updates
void videoVBlankHandler(void);

// Test pattern functions
void videoDrawTestPatternMain(void);
void videoDrawTestPatternSub(void);

// Palette management
void videoLoadPaletteMain(const u16* palette, int offset, int count);
void videoLoadPaletteSub(const u16* palette, int offset, int count);

// BG map updates (called during VBlank)
void videoUpdateMainBG(void);
void videoUpdateSubBG(void);

#ifdef __cplusplus
}
#endif

#endif // SUPERMETROIDDS_VIDEO_H