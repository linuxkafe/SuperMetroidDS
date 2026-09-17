#include "video.h"

int main(void) {
    // Initialize video subsystem (dual-screen)
    videoInit();

    while (1) {
        swiWaitForVBlank();

        if (keysDown() & KEY_START) {
            break;
        }
    }

    return 0;
}