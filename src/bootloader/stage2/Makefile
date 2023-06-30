BUILD_DIR?=build/
ASM?=nasm
CC16?=gcc
LD=ld

ASMFLAGS?=-f elf
CFLAGS16?=-m16 -ffreestanding -nostdlib
LINKERFLAGS?=-T linker.ld -nostdlib

C_SRC_FILES=$(wildcard *.c)
ASM_SRC_FILES=$(wildcard *.asm)
C_OBJ_FILES=$(patsubst %.c, $(BUILD_DIR)/stage2/c/%.o, $(C_SRC_FILES))
ASM_OBJ_FILES=$(patsubst %.asm, $(BUILD_DIR)/stage2/asm/%.o, $(ASM_SRC_FILES))

.PHONY: all stage2 clean always

all: stage2

stage2: $(BUILD_DIR)/stage2.bin

$(BUILD_DIR)/stage2.bin: $(C_OBJ_FILES) $(ASM_OBJ_FILES) linker.ld
	$(LD)$(LDFLAGS) $(LINKERFLAGS) -o $@ $(C_OBJ_FILES) $(ASM_OBJ_FILES) -Map $(BUILD_DIR)/stage2.map

$(BUILD_DIR)/stage2/c/%.o: %.c always
	$(CC16) $(CFLAGS16) -fno-pie -c -o $@ $<

$(BUILD_DIR)/stage2/asm/%.o: %.asm always
	$(ASM) $(ASMFLAGS) -o $@ $<

always:
	mkdir -p $(BUILD_DIR)/stage2/c
	mkdir -p $(BUILD_DIR)/stage2/asm

clean:
	rm -f $(BUILD_DIR)/stage2.bin
