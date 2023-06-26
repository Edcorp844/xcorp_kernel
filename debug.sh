#!/bin/bash

function menu() {
    # ANSI escape sequences for color decorations
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    NC='\033[0m' # No color

    echo -e "${GREEN}Debug option:${NC}"
    echo -e "${YELLOW}[${RED}1${YELLOW}]${GREEN} Image to hex${NC}"
    echo -e "${YELLOW}[${RED}2${YELLOW}]${GREEN} fs${NC}"
    echo -e "${YELLOW}[${RED}3${YELLOW}]${GREEN} bootoptions${NC}"
    
    read -p "Enter your choice: " choice
    
    case $choice in
        1)
	   ./build/tools/debug/readImage build/main_floppy.img img.hex
            ;;
        2)
            echo -e "${GREEN}You chose 'fs'${NC}"
            # Add your code for 'fs' here
            ;;
        3)
            echo -e "${GREEN}You chose 'bootoptions'${NC}"
            # Add your code for 'bootoptions' here
            ;;
        *)
            echo -e "${RED}Invalid choice. Please enter a valid option.${NC}"
            menu # Call the menu function again for another attempt
            ;;
    esac
}

menu

