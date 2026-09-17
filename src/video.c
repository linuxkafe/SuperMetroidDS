#include "video.h"

// BG map bases (16KB each for 256x256 tile map)
#define MAIN_BG0_MAP_BASE  0
#define MAIN_BG1_MAP_BASE  16
#define SUB_BG0_MAP_BASE   0
#define SUB_BG1_MAP_BASE   16

// Tile bases (16KB each for 4bpp tiles)
#define MAIN_BG0_TILE_BASE 0
#define MAIN_BG1_TILE_BASE 1
#define SUB_BG0_TILE_BASE  0
#define SUB_BG1_TILE_BASE  1

// Palette offsets
#define MAIN_PALETTE_OFFSET 0
#define SUB_PALETTE_OFFSET  128

static u16 main_bg0_map[1024];
static u16 main_bg1_map[1024];
static u16 sub_bg0_map[1024];
static u16 sub_bg1_map[1024];

static u16 main_palette[256];
static u16 sub_palette[256];

void videoInit(void) {
    // Main screen: MODE_0_2D (4 BG layers, text mode)
    videoSetMode(MODE_0_2D | DISPLAY_BG0_ACTIVE | DISPLAY_BG1_ACTIVE);

    // Sub screen: MODE_0_2D
    videoSetModeSub(MODE_0_2D | DISPLAY_BG0_ACTIVE | DISPLAY_BG1_ACTIVE);

    // VRAM bank assignment per DESIGN.md
    // A=128KB Main BG, B=128KB Main OBJ, C=128KB Sub BG, D=128KB Sub OBJ, E=64KB Palettes
    vramSetBankA(VRAM_A_MAIN_BG);
    vramSetBankB(VRAM_B_MAIN_SPRITE);
    vramSetBankC(VRAM_C_SUB_BG);
    vramSetBankD(VRAM_D_SUB_SPRITE);
    vramSetBankE(VRAM_E_MAIN_BG);  // Also used for sub palettes via offset

    // Main screen BG0: gameplay layer (256x256 map, 4bpp, tile base 0)
    BGCTRL[0] = BG_32x32 | BG_COLOR_16 | BG_MAP_BASE(MAIN_BG0_MAP_BASE) | BG_TILE_BASE(MAIN_BG0_TILE_BASE);
    BGCTRL[1] = BG_32x32 | BG_COLOR_16 | BG_MAP_BASE(MAIN_BG1_MAP_BASE) | BG_TILE_BASE(MAIN_BG1_TILE_BASE);

    // Sub screen BG0: minimap, BG1: HUD
    BGCTRL_SUB[0] = BG_32x32 | BG_COLOR_16 | BG_MAP_BASE(SUB_BG0_MAP_BASE) | BG_TILE_BASE(SUB_BG0_TILE_BASE);
    BGCTRL_SUB[1] = BG_32x32 | BG_COLOR_16 | BG_MAP_BASE(SUB_BG1_MAP_BASE) | BG_TILE_BASE(SUB_BG1_TILE_BASE);

    // Initialize console on both screens for debugging
    consoleDemoInit();
    consoleDemoInit();

    // Initialize test palettes (grayscale + color bars)
    for (int i = 0; i < 256; i++) {
        int r = (i & 0x1F);
        int g = (i & 0x1F);
        int b = (i & 0x1F);
        main_palette[i] = (b << 10) | (g << 5) | r;
        sub_palette[i] = (b << 10) | (g << 5) | r;
    }

    // Load palettes
    videoLoadPaletteMain(main_palette, 0, 256);
    videoLoadPaletteSub(sub_palette, 0, 256);

    // Draw initial test patterns
    videoDrawTestPatternMain();
    videoDrawTestPatternSub();

    // Register VBlank handler
    irqSet(IRQ_VBLANK, videoVBlankHandler);
    irqEnable(IRQ_VBLANK);
}

void videoVBlankHandler(void) {
    // Update BG maps for both screens
    videoUpdateMainBG();
    videoUpdateSubBG();

    // VBlank is also used for input scanning
    scanKeys();
}

void videoDrawTestPatternMain(void) {
    // Color bars on main screen (BG0)
    for (int y = 0; y < 32; y++) {
        for (int x = 0; x < 32; x++) {
            int color = (x * 8) % 256;
            main_bg0_map[y * 32 + x] = color;  // palette 0
        }
    }

    // "MAIN" text on BG1
    const char* msg = "MAIN SCREEN";
    int start_x = (32 - 11) / 2;
    int start_y = 16;
    for (int i = 0; i < 11; i++) {
        main_bg1_map[start_y * 32 + start_x + i] = (msg[i] - ' ') | (1 << 12);  // palette 1
    }
}

void videoDrawTestPatternSub(void) {
    // Grid pattern on sub screen BG0 (minimap placeholder)
    for (int y = 0; y < 32; y++) {
        for (int x = 0; x < 32; x++) {
            int color = ((x + y) % 2) ? 0x001F : 0x7C00;  // Blue/Red checkerboard
            sub_bg0_map[y * 32 + x] = color;
        }
    }

    // "MINIMAP" text on BG1
    const char* msg = "MINIMAP";
    int start_x = (32 - 7) / 2;
    int start_y = 8;
    for (int i = 0; i < 7; i++) {
        sub_bg1_map[start_y * 32 + start_x + i] = (msg[i] - ' ') | (1 << 12);
    }

    // "HUD" text on BG1 lower
    const char* msg2 = "HUD";
    int start_x2 = (32 - 3) / 2;
    int start_y2 = 24;
    for (int i = 0; i < 3; i++) {
        sub_bg1_map[start_y2 * 32 + start_x2 + i] = (msg2[i] - ' ') | (1 << 12);
    }
}

void videoLoadPaletteMain(const u16* palette, int offset, int count) {
    if (offset + count > 256) count = 256 - offset;
    dmaCopy(palette, &BG_PALETTE[offset], count * sizeof(u16));
}

void videoLoadPaletteSub(const u16* palette, int offset, int count) {
    if (offset + count > 256) count = 256 - offset;
    dmaCopy(palette, &BG_PALETTE_SUB[offset], count * sizeof(u16));
}

void videoUpdateMainBG(void) {
    // Copy BG maps to VRAM (DMA during VBlank)
    dmaCopy(main_bg0_map, (u16*)BG_MAP_RAM(MAIN_BG0_MAP_BASE), sizeof(main_bg0_map));
    dmaCopy(main_bg1_map, (u16*)BG_MAP_RAM(MAIN_BG1_MAP_BASE), sizeof(main_bg1_map));
}

void videoUpdateSubBG(void) {
    dmaCopy(sub_bg0_map, (u16*)BG_MAP_RAM_SUB(SUB_BG0_MAP_BASE), sizeof(sub_bg0_map));
    dmaCopy(sub_bg1_map, (u16*)BG_MAP_RAM_SUB(SUB_BG1_MAP_BASE), sizeof(sub_bg1_map));
}