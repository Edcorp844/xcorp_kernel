#!/bin/bash

# Specify the flash disk device path (e.g., /dev/sdb)
flash_disk="/dev/sdb"

# Confirm the flash disk device path
echo "WARNING: This script will erase all data on ${flash_disk}."
read -p "Are you sure you want to continue? (y/n) " -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Unmount the flash disk if it is mounted
    umount "${flash_disk}"* 2>/dev/null

    # Clean the flash disk
    echo "Cleaning the flash disk..."
    sudo parted -s "${flash_disk}" mklabel msdos
    echo

    # Create a primary partition
    echo "Creating a primary partition..."
    sudo parted -s "${flash_disk}" mkpart primary fat32 0% 100%
    echo

    # Format the partition as FAT32 with the volume label "Lzzie"
    echo "Formatting the partition as FAT32..."
    sudo mkfs.fat -F32 -n "Lizzie" "${flash_disk}1"
    echo

    echo "Flash disk formatting completed!"
else
    echo "Operation cancelled."
fi
