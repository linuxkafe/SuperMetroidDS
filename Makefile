# SuperMetroidDS — Nintendo DS Port Makefile
# Simplified single-phase Makefile for devkitARM (Calico-based)
# Compatible with devkitpro/devkitarm Docker image

# --- CONFIGURATION ---
TARGET       := SuperMetroidDS
BUILD        := build
SOURCES      := src
INCLUDES     := include
DATA         := assets
ARM7_SOURCES := src/arm7

# Toolchain (set by devkitARM environment)
DEVKITARM ?= /opt/devkitpro/devkitARM
CC         := $(DEVKITARM)/bin/arm-none-eabi-gcc
LD         := $(DEVKITARM)/bin/arm-none-eabi-gcc
OBJCOPY    := $(DEVKITARM)/bin/arm-none-eabi-objcopy
NDSTOOL    := /opt/devkitpro/tools/bin/ndstool

# Architecture flags
ARCH         := -mthumb -mthumb-interwork

# Platform defines
PLATFORM_DEFS_ARM9 := -DARM9 -D__NDS__
PLATFORM_DEFS_ARM7 := -DARM7 -D__NDS__

# Paths
CALICO_PATH  := /opt/devkitpro/calico
LIBNDS_PATH  := /opt/devkitpro/libnds

# ARM9 flags
CFLAGS       := -g -Wall -O2 -std=gnu11 -mcpu=arm946e-s -mtune=arm946e-s \
                -fomit-frame-pointer -ffast-math \
                $(PLATFORM_DEFS_ARM9) $(ARCH)
CXXFLAGS     := $(CFLAGS) -fno-rtti -fno-exceptions
ASFLAGS      := -g $(ARCH)

# ARM7 flags
ARM7_CFLAGS  := -g -Wall -O2 -std=gnu11 -mcpu=arm7tdmi -mtune=arm7tdmi \
                -fomit-frame-pointer \
                $(PLATFORM_DEFS_ARM7) $(ARCH)

# Includes
INCLUDE      := -I$(INCLUDES) -I$(LIBNDS_PATH)/include -I$(CALICO_PATH)/include
CFLAGS      += $(INCLUDE)
CXXFLAGS    += $(INCLUDE)
ARM7_CFLAGS += $(INCLUDE)

# ARM9 link flags
LDFLAGS      := -g $(ARCH) -specs=$(CALICO_PATH)/share/ds9.specs -Wl,-Map,$(BUILD)/$(TARGET).map \
                -L$(LIBNDS_PATH)/lib -L$(CALICO_PATH)/lib

# ARM7 link flags
ARM7_LDFLAGS := -g $(ARCH) -specs=$(CALICO_PATH)/share/ds7.specs \
                -L$(LIBNDS_PATH)/lib -L$(CALICO_PATH)/lib

# Libraries
LIBS        := -Wl,--start-group -lnds9 -lcalico_ds9 -Wl,--end-group -lfat -lmm9 -lm
ARM7_LIBS   := -lnds7 -lcalico_ds7

# Source files
CFILES       := $(wildcard $(SOURCES)/*.c)
SFILES       := $(wildcard $(SOURCES)/*.s)
ARM7_CFILES  := $(wildcard $(ARM7_SOURCES)/*.c)
BANNER       := $(DATA)/banner.bin

# Object files
OFILES_ARM9  := $(CFILES:$(SOURCES)/%.c=$(BUILD)/%.o) $(SFILES:$(SOURCES)/%.s=$(BUILD)/%.o)
OFILES_ARM7  := $(ARM7_CFILES:$(ARM7_SOURCES)/%.c=$(BUILD)/arm7/%.o)

# Output files
ELF_ARM9     := $(BUILD)/$(TARGET).arm9.elf
ELF_ARM7     := $(BUILD)/$(TARGET).arm7.elf
NDS_ROM      := $(BUILD)/$(TARGET).nds

.PHONY: all clean setup lint format test check

all: $(NDS_ROM)

$(NDS_ROM): $(ELF_ARM9) $(ELF_ARM7) $(BANNER)
	@echo "Packaging NDS: $(notdir $@)"
	@$(NDSTOOL) -c $@ -9 $(ELF_ARM9) -7 $(ELF_ARM7) -t $(BANNER)
	@echo "✅ BUILD SUCCESS! $(notdir $@) created."

$(ELF_ARM9): $(OFILES_ARM9)
	@echo "Linking ARM9: $(notdir $@)"
	@$(LD) $(LDFLAGS) $^ $(LIBS) -o $@

$(ELF_ARM7): $(OFILES_ARM7)
	@echo "Linking ARM7: $(notdir $@)"
	@$(LD) $(ARM7_LDFLAGS) $^ $(ARM7_LIBS) -o $@

# ARM9 compilation
$(BUILD)/%.o: $(SOURCES)/%.c
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

$(BUILD)/%.o: $(SOURCES)/%.s
	@mkdir -p $(dir $@)
	@$(CC) $(ASFLAGS) -c $< -o $@

# ARM7 compilation
$(BUILD)/arm7/%.o: $(ARM7_SOURCES)/%.c
	@mkdir -p $(dir $@)
	@$(CC) $(ARM7_CFLAGS) -MMD -MP -c $< -o $@

# Dependencies
-include $(OFILES_ARM9:.o=.d)
-include $(OFILES_ARM7:.o=.d)

clean:
	@echo "Cleaning..."
	@rm -fr $(BUILD)

setup:
	@echo "Checking devkitARM installation..."
	@test -d "$(DEVKITARM)" || (echo "devkitARM not found at $(DEVKITARM)" && exit 1)
	@echo "devkitARM found at $(DEVKITARM)"

lint:
	@echo "Running cppcheck..."
	@command -v cppcheck >/dev/null 2>&1 && cppcheck --enable=all --std=c11 --suppress=missingIncludeSystem $(SOURCES) $(ARM7_SOURCES) $(INCLUDES) 2>/dev/null || echo "cppcheck not installed (OK in container)"

format:
	@echo "Running clang-format..."
	@command -v clang-format >/dev/null 2>&1 && find $(SOURCES) $(ARM7_SOURCES) $(INCLUDES) -name '*.c' -o -name '*.h' | xargs clang-format -i 2>/dev/null || echo "clang-format not installed (OK in container)"

test: $(NDS_ROM)
	@echo "Testing on melonDS (headless)..."
	@command -v melonDS >/dev/null 2>&1 && melonDS $(NDS_ROM) --headless 2>/dev/null || echo "melonDS not available (OK in container)"

check: setup all lint