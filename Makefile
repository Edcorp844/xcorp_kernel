#XCORP-kernel is under the license of X-CORPERATIONS.inc.
#The software license is MIT Open Source.
#Using this piece of software for commercial purposes can lead to pressment of charges acording to the terms and conditions tha apply to the use of this software.
#Developer : Frost Edson.
#Developement community: NanoByte Os Development.
#All rights reserved for XCORP.

ASM = nasm

SRC_DIR = src
BUILD_DIR =build
TOOLS_DIR = tools

include buildScripts/config.mk

.PHONY: all floppy_img kernel bootloader clean always #tools_fat

#all
all: floppy_img tools_fat debug_tools bootloader

include buildScripts/toolChains.mk

#floppy img

floppy_img: $(BUILD_DIR)/main_floppy.img

$(BUILD_DIR)/main_floppy.img: bootloader kernel
	@dd if=/dev/zero of=$@ bs=512 count=2880 >/dev/null
	@mkfs.fat -F 12 -n "XCORP" $@ >/dev/null
	@dd if=$(BUILD_DIR)/stage1.bin of=$@ conv=notrunc >/dev/null
	@mcopy -i $@ $(BUILD_DIR)/stage2.bin "::stage2.bin"
	@mcopy -i $@ $(BUILD_DIR)/kernel.bin "::kernel.bin"
	@mcopy -i $@ test.txt "::test.txt"
	@mmd -i $@ "::bin"
	@mmd -i $@ "::dev"
	@mmd -i $@ "::etc"
	@mmd -i $@ "::Library"
	@mmd -i $@ "::Usr"
	@mmd -i $@ "::Users"
	@mmd -i $@ "::Applications"
	@mmd -i $@ "::Volumes"
	@mmd -i $@ "::tmp"
	@mmd -i $@ "::var"
	@mmd -i $@ "::private"
	@mcopy -i $@ test.txt "::Users/test.txt"
	@echo "--> Created: " $@

bootloader: stage1 stage2

stage1: $(BUILD_DIR)/stage1.bin

$(BUILD_DIR)/stage1.bin: always
	@$(MAKE) -C src/bootloader/stage1 BUILD_DIR=$(abspath $(BUILD_DIR))

stage2: $(BUILD_DIR)/stage2.bin

$(BUILD_DIR)/stage2.bin: always
	@$(MAKE) -C src/bootloader/stage2 BUILD_DIR=$(abspath $(BUILD_DIR))

#
# Kernel
#
kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	@$(MAKE) -C src/kernel BUILD_DIR=$(abspath $(BUILD_DIR))
# TOOLS
# FAT tools
#tools_fat: $(BUILD_DIR)/tools/fat

#$(BUILD_DIR)/tools/fat: $(TOOLS_DIR)/FAT12/fat.c $(TOOLS_DIR)/FAT12/headers/fat12.h $(TOOLS_DIR)/FAT12/fat12.c
#	gcc -o $(BUILD_DIR)/tools/fat $(TOOLS_DIR)/FAT12/fat.c $(TOOLS_DIR)/FAT12/fat12.c -I$(TOOLS_DIR)/FAT12/headers

#Debug tools
debug_tools: always $(BUILD_DIR)/tools/debug/readImage

$(BUILD_DIR)/tools/debug/readImage: $(TOOLS_DIR)/DEBUG/readImage.c
	gcc -o $(BUILD_DIR)/tools/debug/readImage $(TOOLS_DIR)/DEBUG/readImage.c

#always
always:
	mkdir -p $(BUILD_DIR)/tools/debug

#clean
clean:
	$(MAKE) -C $(SRC_DIR)/bootloader/stage1 BUILD_DIR=$(CURDIR)/$(BUILD_DIR) clean
	$(MAKE) -C $(SRC_DIR)/bootloader/stage2 BUILD_DIR=$(CURDIR)/$(BUILD_DIR) clean
	$(MAKE) -C $(SRC_DIR)/kernel BUILD_DIR=$(CURDIR)/$(BUILD_DIR) clean
	rm -rf $(BUILD_DIR)/*
	rmdir $(BUILD_DIR)

