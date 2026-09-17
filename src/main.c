#include <nds.h>

int main(void) {
    // Minimal ARM9 entry - just VBlank loop
    // Calico uses different IRQ/console APIs, so keep it minimal for now

    while (1) {
        swiWaitForVBlank();
    }

    return 0;
}