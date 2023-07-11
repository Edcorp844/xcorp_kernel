#ifndef _FAT_12_H
#define _FAT_12_H

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define true 1
#define false 0
typedef uint8_t bool;

#pragma once

typedef struct {
    uint8_t BootJumpInstruction;
    uint8_t OemIdentifier;
    uint16_t BytesPerSector;
    uint8_t SectorePerCluster;
    uint16_t ReservedSectors;
    uint8_t FatCount;
    uint16_t DirEntryCount;
    uint16_t TotalSector;
    uint8_t MediaDescriptorCount;
    uint16_t SectorsPerFat;
    uint16_t SectorsPerTrack;
    uint16_t Heads;
    uint32_t HiddenSectors;
    uint32_t LargeSectorCount;

    //Extended boot record
    uint8_t DriveNumber;
    uint8_t _Reserverd;
    uint8_t Signature;
    uint32_t volumeId;
    uint8_t VolueLable[11];
    uint8_t SystemId[8];
} __attribute__((packed)) BootSector;

typedef struct {
    /* data */
    uint8_t Name[11];
    uint8_t Attributes;
    uint8_t _Reserved;
    uint8_t CreatedTimeTenths;
    uint16_t CreatedTime;
    uint16_t CreatedDate;
    uint16_t AccessedDate;
    uint16_t FirstClusterHigh;
    uint16_t ModifiedTime;
    uint16_t ModifiedDate;
    uint16_t FirstClusterLow;
    uint32_t Size;
} __attribute__((packed)) DirectoryEntry;




bool readBootSector(FILE *disk, BootSector *bootsector);
//bool readSector(FILE* disk, uint32_t lba, uint32_t Count, void* BufferOut, BootSector bootsector);
//bool readfat(FILE* disk, BootSector bootsector, uint8_t* fat);
bool readSector(FILE* disk, uint32_t lba, uint32_t Count, void* BufferOut, const BootSector* bootsector);
bool readfat(FILE* disk, const BootSector* bootsector, uint8_t** fat);

bool readRootDirectory(FILE* disk, BootSector bootsector, DirectoryEntry* RootDirectory);
//DirectoryEntry *findFile(const char *name, BootSector bootsector, DirectoryEntry* RootDirectory);
DirectoryEntry* findFile(const char* name, const BootSector* bootsector, DirectoryEntry* RootDirectory);


#endif
