#include <nds.h>

int main(void) {
    // Minimal ARM7 entry - just VBlank loop
    // Calico ARM7 may not have irqInit/irqEnable

    while (1) {
        swiWaitForVBlank();
    }

    return 0;
}