#XCORP-OS is under the license of X-CORPERATIONS.inc.
#The software license is MIT Open Source.
#Using this piece of software for commercial purposes can lead to pressment of charges acording to the terms and conditions tha apply to the use of this software.
#Developer : Frost Edson.
#Developement community: NanoByte Os Development.
#All rights reserved for XCORP.

ASM = nasm

SRC_DIR = src
BUILD_DIR =build
TOOLS_DIR = tools

.PHONY: all floppy_img kernel bootloader clean always tools_fat

#all
all: tools_fat debug_tools floppy_img

#floppy img

floppy_img: $(BUILD_DIR)/main_floppy.img

$(BUILD_DIR)/main_floppy.img: bootloader kernel
	dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880
	mkfs.fat -F 12 -n "XCORP OS" $(BUILD_DIR)/main_floppy.img
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/main_floppy.img conv=notrunc
	mcopy -i $(BUILD_DIR)/main_floppy.img $(BUILD_DIR)/kernel.bin "::kernel.bin"
	mcopy -i $(BUILD_DIR)/main_floppy.img $(TOOLS_DIR)/FAT12/test.txt "::text.txt"

#bootloader
bootloader: $(BUILD_DIR)/bootloader.bin

$(BUILD_DIR)/bootloader.bin: always
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin

#kernel
kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o $(BUILD_DIR)/kernel.bin

# TOOLS
# FAT tools
tools_fat: $(BUILD_DIR)/tools/fat

$(BUILD_DIR)/tools/fat: $(TOOLS_DIR)/FAT12/fat.c $(TOOLS_DIR)/FAT12/headers/fat12.h $(TOOLS_DIR)/FAT12/fat12.c
	gcc -o $(BUILD_DIR)/tools/fat $(TOOLS_DIR)/FAT12/fat.c $(TOOLS_DIR)/FAT12/fat12.c -I$(TOOLS_DIR)/FAT12/headers

#Debug tools
debug_tools: always $(BUILD_DIR)/tools/debug/readImage

$(BUILD_DIR)/tools/debug/readImage: $(TOOLS_DIR)/DEBUG/readImage.c
	gcc -o $(BUILD_DIR)/tools/debug/readImage $(TOOLS_DIR)/DEBUG/readImage.c

#always
always:
	mkdir -p $(BUILD_DIR)/tools/debug

#clean
clean:
	rm -rf $(BUILD_DIR)/*


