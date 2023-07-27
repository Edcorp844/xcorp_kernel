#include<stdio.h>

int main(int argc, char **argv) {
	if(argc < 3){
		printf("Syntax: %s <image> <file to write>\n", argv[0]);
		return -1;
	}

    FILE *binaryFile = fopen(argv[1], "rb");
    FILE *hexFile = fopen(argv[2], "w");

    if (binaryFile == NULL) {
        printf("Failed to open binary file.\n");
        return 1;
    }

    if (hexFile == NULL) {
        printf("Failed to open output text file.\n");
        return 1;
    }

    unsigned char buffer[1024];
    size_t bytesRead;

    while ((bytesRead = fread(buffer, sizeof(unsigned char), sizeof(buffer), binaryFile)) > 0) {
        for (size_t i = 0; i < bytesRead; i++) {
            fprintf(hexFile, "%02X ", buffer[i]);
        }
    }

    fclose(binaryFile);
    fclose(hexFile);

    printf("Conversion complete.\n");

    return 0;
}