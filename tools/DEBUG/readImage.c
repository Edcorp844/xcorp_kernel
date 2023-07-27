#include <stdio.h>

int main(int argc, char **argv) {
    if (argc < 3) {
        printf("Syntax: %s <image> <file to write>\n", argv[0]);
        return -1;
    }

    FILE *binaryFile = fopen(argv[1], "rb");
    FILE *outputFile = fopen(argv[2], "w");

    if (binaryFile == NULL) {
        printf("Failed to open binary file.\n");
        return 1;
    }

    if (outputFile == NULL) {
        printf("Failed to open output file.\n");
        return 1;
    }

    unsigned char buffer[1024];
    size_t bytesRead;

    fprintf(outputFile, "FAT DEBUG 1.20: written by Frost Edson\n\n");

    fprintf(outputFile, "Boot Jump Instruction   : ");
    unsigned char bootJump[3];
    if (fread(bootJump, sizeof(unsigned char), 3, binaryFile) != 3) {
        printf("Failed to read binary file.\n");
        fclose(binaryFile);
        fclose(outputFile);
        return 1;
    }

    if (bootJump[0] != 0xEB || bootJump[1] != 0x3C || bootJump[2] != 0x90) {
        // No boot jump instruction, read Oem Identifier instead
        fprintf(outputFile, "\n");
        fprintf(outputFile, "Oem Identifier          : ");
        for (int i = 0; i < 8; i++) {
            unsigned char byte;
            if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
                printf("Failed to read binary file.\n");
                fclose(binaryFile);
                fclose(outputFile);
                return 1;
            }
            fprintf(outputFile, "%02X ", byte);
        }
        fprintf(outputFile, "\n");
    } else {
        // Boot jump instruction is present
        for (int i = 0; i < 3; i++) {
            fprintf(outputFile, "%02X ", bootJump[i]);
        }
        fprintf(outputFile, "\n");
    }


    fprintf(outputFile, "Bytes Per Sector        : ");
    for (int i = 0; i < 2; i++) {
        unsigned char byte;
        if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
            printf("Failed to read binary file.\n");
            fclose(binaryFile);
            fclose(outputFile);
            return 1;
        }
        fprintf(outputFile, "%02X ", byte);
    }
    fprintf(outputFile, "\n");

    fprintf(outputFile, "Sectors Per Cluster     : ");
    unsigned char byte;
    if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
        printf("Failed to read binary file.\n");
        fclose(binaryFile);
        fclose(outputFile);
        return 1;
    }
    fprintf(outputFile, "%02X\n", byte);

    fprintf(outputFile, "Reserved Sectors        : ");
    for (int i = 0; i < 2; i++) {
        unsigned char byte;
        if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
            printf("Failed to read binary file.\n");
            fclose(binaryFile);
            fclose(outputFile);
            return 1;
        }
        fprintf(outputFile, "%02X ", byte);
    }
    fprintf(outputFile, "\n");

    fprintf(outputFile, "Fat Count               : ");
    if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
        printf("Failed to read binary file.\n");
        fclose(binaryFile);
        fclose(outputFile);
        return 1;
    }
    fprintf(outputFile, "%02X\n", byte);

    fprintf(outputFile, "Dir Entry Count         : ");
    for (int i = 0; i < 2; i++) {
        unsigned char byte;
        if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
            printf("Failed to read binary file.\n");
            fclose(binaryFile);
            fclose(outputFile);
            return 1;
        }
        fprintf(outputFile, "%02X ", byte);
    }
    fprintf(outputFile, "\n");

    fprintf(outputFile, "Total sectors           : ");
    for (int i = 0; i < 2; i++) {
        unsigned char byte;
        if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
            printf("Failed to read binary file.\n");
            fclose(binaryFile);
            fclose(outputFile);
            return 1;
        }
        fprintf(outputFile, "%02X ", byte);
    }
    fprintf(outputFile, "\n");

    fprintf(outputFile, "Media Descriptor Type   : ");
    if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
        printf("Failed to read binary file.\n");
        fclose(binaryFile);
        fclose(outputFile);
        return 1;
    }
    fprintf(outputFile, "%02X\n", byte);

    fprintf(outputFile, "Sectors Per Fat         : ");
    for (int i = 0; i < 2; i++) {
        unsigned char byte;
        if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
            printf("Failed to binary file.\n");
            fclose(binaryFile);
            fclose(outputFile);
            return 1;
        }
        fprintf(outputFile, "%02X ", byte);
    }
    fprintf(outputFile, "\n");

        fprintf(outputFile, "Sectors Per Track       : ");
    for (int i = 0; i < 2; i++) {
        unsigned char byte;
        if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
            printf("Failed to read binary file.\n");
            fclose(binaryFile);
            fclose(outputFile);
            return 1;
        }
        fprintf(outputFile, "%02X ", byte);
    }
    fprintf(outputFile, "\n");

    fprintf(outputFile, "Heads                   : ");
    for (int i = 0; i < 2; i++) {
        unsigned char byte;
        if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
            printf("Failed to read binary file.\n");
            fclose(binaryFile);
            fclose(outputFile);
            return 1;
        }
        fprintf(outputFile, "%02X ", byte);
    }
    fprintf(outputFile, "\n");

    fprintf(outputFile, "Hidden Sectors          : ");
    for (int i = 0; i < 4; i++) {
        unsigned char byte;
        if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
            printf("Failed to read binary file.\n");
            fclose(binaryFile);
            fclose(outputFile);
            return 1;
        }
        fprintf(outputFile, "%02X ", byte);
    }
    fprintf(outputFile, "\n");

    fprintf(outputFile, "Large Sector Count      : ");
    for (int i = 0; i < 4; i++) {
        unsigned char byte;
        if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
            printf("Failed to read binary file.\n");
            fclose(binaryFile);
            fclose(outputFile);
            return 1;
        }
        fprintf(outputFile, "%02X ", byte);
    }
    fprintf(outputFile, "\n\n");

    fprintf(outputFile, "// Extended Boot Record\n");
    fprintf(outputFile, "Ebr Drive Number        : ");
    if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
        printf("Failed to read binary file.\n");
        fclose(binaryFile);
        fclose(outputFile);
        return 1;
    }
    fprintf(outputFile, "%02X\n", byte);

    fprintf(outputFile, "Reserved                : ");
    if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
        printf("Failed to read binary file.\n");
        fclose(binaryFile);
        fclose(outputFile);
        return 1;
    }
    fprintf(outputFile, "%02X\n", byte);

    fprintf(outputFile, "Signature               : ");
    if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
        printf("Failed to read binary file.\n");
        fclose(binaryFile);
        fclose(outputFile);
        return 1;
    }
    fprintf(outputFile, "%02X\n", byte);

    fprintf(outputFile, "Volume Id               : ");
    for (int i = 0; i < 4; i++) {
        unsigned char byte;
        if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
            printf("Failed to read binary file.\n");
            fclose(binaryFile);
            fclose(outputFile);
            return 1;
        }
        fprintf(outputFile, "%02X ", byte);
    }
    fprintf(outputFile, "\n");

    fprintf(outputFile, "Volume Label            : ");
    for (int i = 0; i < 11; i++) {
        unsigned char byte;
        if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
            printf("Failed to read binary file.\n");
            fclose(binaryFile);
            fclose(outputFile);
            return 1;
        }
        fprintf(outputFile, "%02X ", byte);
    }
    fprintf(outputFile, "\n");

    fprintf(outputFile, "System Id               : ");
    for (int i = 0; i < 8; i++) {
        unsigned char byte;
        if (fread(&byte, sizeof(unsigned char), 1, binaryFile) != 1) {
            printf("Failed to read binary file.\n");
            fclose(binaryFile);
            fclose(outputFile);
            return 1;
        }
        fprintf(outputFile, "%02X ", byte);
    }
    fprintf(outputFile, "\n\n\n");
    fprintf(outputFile, "\n//The rest of the file");
    fprintf(outputFile, "\n\n\n");

    //unsigned char byte;
    int c = 0;
    while (fread(&byte, sizeof(unsigned char), 1, binaryFile) == 1) {
        c ++;
        fprintf(outputFile, "%02X ", byte);
        if (c == 16) {
            fprintf(outputFile, "\n");
            c = 0;
        }
    }

    fclose(binaryFile);
    fclose(outputFile);

    printf("Conversion complete.\n");

    return 0;
}
