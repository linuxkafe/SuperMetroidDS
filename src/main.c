#include <nds.h>

int main(void) {
    irqInit();
    irqEnable(IRQ_VBLANK);

    videoSetMode(MODE_0_2D);
    videoSetModeSub(MODE_0_2D);

    vramSetBankA(VRAM_A_MAIN_BG);
    vramSetBankC(VRAM_C_SUB_BG);

    consoleDemoInit();
    consoleDemoInit();

    iprintf("\x1b[10;5HSuperMetroidDS");
    iprintf("\x1b[12;5HARM9: Build OK");

    while (1) {
        swiWaitForVBlank();
        scanKeys();
        if (keysDown() & KEY_START) break;
    }

    return 0;
}