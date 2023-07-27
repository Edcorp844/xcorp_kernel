#!/bin/bash

build_folder="build"
stage1_bin="stage1.bin"
stage2_bin="stage2.bin"
main_floppy="main_floppy.img"

function menu() {
    # ANSI escape sequences for color decorations
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    PURPLE='\033[0;35m'
    NC='\033[0m' # No color


echo -e "${YELLOW}__  __      ____                   ____  _____ ${GREEN}____  _   _  ____ "
echo -e "${YELLOW}\\ \\/ /     / ___|___  _ __ _ __   |  _ \\| ${GREEN}____| __ )| | | |/ ___|"
echo -e "${YELLOW} \\  /_____| |   / _ \\| '__| '_ \\  | | | | ${GREEN}_|  |  _ \\| | | | |  _ "
echo -e "${YELLOW} /  \\_____| |__| (_) | |  | |_) | | |_| | ${GREEN}|___| |_) | |_| | |_| |"
echo -e "${YELLOW}/_/\\_\\     \\____\\___/|_|  | .__/  |____/|${GREEN}_____|____/ \\___/ \\____|"
echo -e "${YELLOW}                          |_|${NC}"


    echo -e "${GREEN}Debug option:${NC}"
    echo -e "${YELLOW}[${RED}1${YELLOW}]${GREEN} Image to hex${NC}"
    echo -e "${YELLOW}[${RED}2${YELLOW}]${GREEN} Stage1.bin to hex${NC}"
    echo -e "${YELLOW}[${RED}3${YELLOW}]${GREEN} Stage2.bin to hex${NC}"
    echo -e "${YELLOW}[${RED}4${YELLOW}]${GREEN} Boot from stage1.bin${NC}"
    echo -e "${YELLOW}[${RED}5${YELLOW}]${GREEN} Boot from floppyImage${NC}"

    read -p "Enter your choice: " choice

    case $choice in
        1)
            # Check if the file exists in the build folder
            if [ -e "$build_folder/$main_floppy" ]; then
                 ./build/tools/debug/readImage $build_folder/$main_floppy img.hex
            else
                 echo -e "${RED}[X] Error. ${NC}$main_floppy does not exist."
            fi
            ;;
        2)
            if [ -e "$build_folder/$stage1_bin" ]; then
                 ./build/tools/debug/readImage $build_folder/$stage1_bin stage1.hex
            else
                 echo -e "${RED}[X] Error. ${NC}$stage1_bin does not exist."
            fi
            ;;
        3)
            if [ -e "$build_folder/$stage2_bin" ]; then
                 ./build/tools/debug/readImage $build_folder/$stage2_bin stage2.hex
            else
                 echo -e "${RED}[X] Error. ${NC}$stage2_bin does not exist."
            fi
            ;;
        4)
           if [ -e "$build_folder/$stage1_bin" ]; then
                 qemu-system-x86_64 -hda $build_folder/$stage1_bin
            else
                 echo -e "${RED}[X] Error. ${NC}$stage1_bin does not exist."
            fi
            ;;
        5)
           if [ -e "$build_folder/$main_floppy" ]; then
                 qemu-system-x86_64 -fda $build_folder/$main_floppy
            else
                 echo -e "${RED}[X] Error. ${NC}$main_floppy does not exist."
            fi
            ;;
        *)
            echo -e "${RED}Invalid choice. Please enter a valid option.${NC}"
            menu # Call the menu function again for another attempt
            ;;
    esac
}

menu

