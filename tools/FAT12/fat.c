/*
THE FAT 12 FS
CREATED BY FROST EDSON ON MAY 1, 2023
*/

#include "headers/fat12.h"

BootSector g_bootSector;
uint8_t* g_fat = NULL;
DirectoryEntry* g_RootDirectory;



int main(int argc, char **argv) {

    if (argc < 3) {
        printf("\033[31m[X] Error 0001\n");
        printf("\033[31m[X] \033[33;44mSyntax:\033[0m %s \033[32m<disk image> \033[35m<file name>\n", argv[0]);
        return -1;
    }
    printf("\n\n\033[35m[+] \033[36m\033[43mInitializing FAT12\033[0m by \033[36mFROST EDSON\033[0m\n\n");

    FILE* disk = fopen(argv[1], "rb");

    if(!disk) {
        fprintf(stderr, "\033[31m[X] \033[41mError 0002\033[0m: Cannot open disk image %s \033[35m:(", argv[1]);
        return -1;
    }
    printf("\033[32m[✔️] \033[0mDisk image opened \033[36m:)\n");

    if(!readBootSector(disk, g_bootSector)) {
        fprintf(stderr, "\\033[31m[X] \033[41mError 0003\033[0m: Could not read boot sector \033[35m:(\n");
        return -2;
    }
     printf("\033[32m[✔️] \033[0mBoot sector read successfully \033[36m:)\n");


    if(!readfat(disk, g_bootSector, g_fat)) {
        fprintf(stderr, "\033[31m[X] \033[0m\033[41mError 0004\033[0m: Could not read FAT \033[35m:( \n");
        free(g_fat);
        return -3;
    }
      printf("\033[32m[✔️] \033[0mFAT read successfully \033[36m:)\n");


    if(!readRootDirectory(disk, g_bootSector, g_RootDirectory)) {
        fprintf(stderr, "\\033[31m[X] \033[41mError 0005\033[0m: Could not read Rood Directory \033[35m:(\n");
        free(g_fat);
        free(g_RootDirectory);
        return -3;
    }
     printf("\033[32m[✔️] \033[0mRoot directory read successfully \033[36m:)\n");

    DirectoryEntry* fileEntry = findFile(argv[2], g_bootSector, g_RootDirectory);
    if(!fileEntry) {
        fprintf(stderr, "\033[31m[X] \033[0m\033[41mError 0005\033[0m: Could not find file %s \033[35m:(\n", argv[2]);
        free(g_fat);
        free(g_RootDirectory);
        return -5;
    }

    free(g_fat);
    free(g_RootDirectory);

    return EXIT_SUCCESS;
}
