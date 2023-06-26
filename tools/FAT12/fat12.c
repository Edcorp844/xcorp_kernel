#include "headers/fat12.h"

bool readBootSector(FILE *disk, BootSector bootsector) {
    return fread(&bootsector, sizeof(bootsector),1, disk) > 0;
}

bool readSector(FILE* disk, uint32_t lba, uint32_t Count, void* BufferOut, BootSector bootsector){
    bool ok = true;
    ok = ok && (fseek(disk, lba * bootsector.BytesPerSector, SEEK_SET) ==0);
    ok = ok && (fread(BufferOut, bootsector.BytesPerSector, Count, disk) == Count);
    return ok;
}

bool readfat(FILE* disk, BootSector bootsector, uint8_t* fat) {
    fat = (uint8_t*) malloc(bootsector.SectorsPerFat * bootsector.BytesPerSector);
    return readSector(disk, bootsector.ReservedSectors, bootsector.SectorsPerFat, fat, bootsector);
}

bool readRootDirectory(FILE* disk, BootSector bootsector, DirectoryEntry* RootDirectory) {
	uint32_t lba = bootsector.ReservedSectors + bootsector.SectorsPerFat *bootsector.FatCount;
   	uint32_t size = sizeof(DirectoryEntry) * bootsector.DirEntryCount;
	uint32_t sectors = (size / bootsector.BytesPerSector);
	if (size % bootsector.BytesPerSector > 0) {
		sectors++;
    	}

	RootDirectory = (DirectoryEntry*) malloc(sectors * bootsector.BytesPerSector);
	return readSector(disk, lba, sectors, RootDirectory, bootsector);
}

DirectoryEntry *findFile(const char *name, BootSector bootsector, DirectoryEntry* RootDirectory) {
    for(int32_t i = 0; i < bootsector.DirEntryCount; i++) {
        if (memcmp(name, RootDirectory[i].Name, 11))
            return &RootDirectory[i];
    }
    return NULL;
}
