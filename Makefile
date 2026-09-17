.PHONY: setup run test lint format build check doctor help clean

AES_LANGUAGE := c
DEVKITARM ?= /opt/devkitpro/devkitARM
LIBNDS ?= /opt/devkitpro/libnds
export DEVKITARM LIBNDS

CC := $(DEVKITARM)/bin/arm-none-eabi-gcc
LD := $(DEVKITARM)/bin/arm-none-eabi-gcc
OBJCOPY := $(DEVKITARM)/bin/arm-none-eabi-objcopy
CFLAGS := -std=c11 -ffreestanding -O2 -Wall -Wextra -Wno-unused-parameter \
          -Iinclude -Isrc -I$(LIBNDS)/include -DARM9
LDFLAGS := -specs=ds_arm9.specs -Wl,-Map,build/SuperMetroidDS.map
LIBS := -lnds9 -lfat -lmm9

BUILD_DIR := build
SRC_DIR := src
GEN_DIR := $(SRC_DIR)/gen
ARM7_DIR := $(SRC_DIR)/arm7

SOURCES_ARM9 := $(wildcard $(SRC_DIR)/*.c) $(wildcard $(GEN_DIR)/*.c)
OBJECTS_ARM9 := $(SOURCES_ARM9:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)

SOURCES_ARM7 := $(wildcard $(ARM7_DIR)/*.c)
OBJECTS_ARM7 := $(SOURCES_ARM7:$(ARM7_DIR)/%.c=$(BUILD_DIR)/arm7/%.o)

TARGET_NDS := $(BUILD_DIR)/SuperMetroidDS.nds
TARGET_ELF9 := $(BUILD_DIR)/SuperMetroidDS.arm9.elf
TARGET_ELF7 := $(BUILD_DIR)/SuperMetroidDS.arm7.elf

setup:
	@echo "Checking devkitARM installation..."
	@test -d "$(DEVKITARM)" || (echo "devkitARM not found at $(DEVKITARM). Install devkitPro." && exit 1)
	@test -d "$(LIBNDS)" || (echo "libnds not found at $(LIBNDS). Install devkitPro." && exit 1)
	@echo "devkitARM found. Run 'make build' to compile."

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/arm7/%.o: $(ARM7_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -DARM7 -c $< -o $@

$(TARGET_ELF9): $(OBJECTS_ARM9)
	$(LD) $(LDFLAGS) -o $@ $^ $(LIBS)

$(TARGET_ELF7): $(OBJECTS_ARM7)
	$(LD) -specs=ds_arm7.specs -o $@ $^ -lnds7

$(TARGET_NDS): $(TARGET_ELF9) $(TARGET_ELF7)
	$(DEVKITARM)/bin/ndstool -c $@ -9 $(TARGET_ELF9) -7 $(TARGET_ELF7) -b assets/banner.bin

build: $(TARGET_NDS)
	@echo "Built $(TARGET_NDS)"

run: build
	@echo "Run on hardware: copy $(TARGET_NDS) to flashcart"
	@echo "Run on emulator: melonDS $(TARGET_NDS)"

test:
	@echo "Testing on melonDS..."
	@command -v melonDS >/dev/null 2>&1 && melonDS $(TARGET_NDS) --headless || echo "melonDS not in PATH"

lint:
	@echo "Running cppcheck..."
	@command -v cppcheck >/dev/null 2>&1 && cppcheck --enable=all --std=c11 --suppress=missingIncludeSystem $(SRC_DIR) $(ARM7_DIR) || echo "cppcheck not installed"

format:
	@echo "Running clang-format..."
	@command -v clang-format >/dev/null 2>&1 && find $(SRC_DIR) $(ARM7_DIR) -name '*.c' -o -name '*.h' | xargs clang-format -i || echo "clang-format not installed"

clean:
	rm -rf $(BUILD_DIR)

check: docs-check build lint

docs-check:
	@test -f docs/VISION.md && grep -q "Problem" docs/VISION.md
	@test -f docs/PERSONAS.md && grep -q "User" docs/PERSONAS.md
	@test -f docs/REQUIREMENTS.md && grep -q "Functional" docs/REQUIREMENTS.md
	@test -f docs/ROADMAP.md && grep -q "Roadmap" docs/ROADMAP.md

doctor:
	@echo "Language: C (devkitARM)"
	@echo "devkitARM: $(DEVKITARM)"
	@echo "libnds: $(LIBNDS)"
	@test -d "$(DEVKITARM)" && echo "devkitARM: OK" || echo "devkitARM: MISSING"
	@test -d "$(LIBNDS)" && echo "libnds: OK" || echo "libnds: MISSING"

help:
	@echo "AES Commands for SuperMetroidDS:"
	@echo "  make setup   - Verify devkitARM installation"
	@echo "  make build   - Compile .nds ROM"
	@echo "  make run     - Show run instructions"
	@echo "  make test    - Test on melonDS (headless)"
	@echo "  make lint    - Run cppcheck"
	@echo "  make format  - Run clang-format"
	@echo "  make check   - Full validation (docs + build + lint)"
	@echo "  make clean   - Remove build artifacts"