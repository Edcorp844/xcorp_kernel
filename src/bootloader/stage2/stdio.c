#include "stdio.h"
#include "x86.h"

void putc(char c) {
	x86_video_writeCharTeletype(c, 0);
}

void puts(const char* str) {
	while (*str) {
		putc(*str);

		str++;
	}
}