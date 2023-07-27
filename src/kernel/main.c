#include <stdint.h>
#include "stdio.h"
#include "memory.h"
#include <hal/hal.h>
#include <arch/i686/audio.h>
#include <arch/i686/x86.h>
#include <arch/i686/disk.h>
#include "fat.h"
#include "memdefs.h"
#include "memory.h"
#include <arch/i686/io.h>


extern uint8_t __bss_start;
extern uint8_t __end;

uint8_t* KernelLoadBuffer = (uint8_t*)MEMORY_LOAD_KERNEL;
uint8_t* Kernel = (uint8_t*)MEMORY_KERNEL_ADDR;

uint8_t * FatMemoryAddress = (uint8_t*)MEMORY_FAT_ADDR;
uint8_t* FatMemorySize =  (uint8_t*)MEMORY_FAT_SIZE;

void __attribute__((section(".entry"))) start(uint16_t bootDrive)
{
    memset(&__bss_start, 0, (&__end) - (&__bss_start));

    HAL_Initialize();

    clrscr();

    timer_wait(10);
    printf("\t\t\t\tX-CORP KERNEL\n\n\n");
    beep();
    printf("\tBootdrive : %d", bootDrive);
    printf("\n\tbss_start : %d", __bss_start);
    printf("\n\tend : %d", __end);
    printf("\n\tkernel load buffer : %d", &KernelLoadBuffer);
    printf("\n\tkernel : %d", &Kernel);
    printf("\n\tFat Memory Address : %d", &FatMemoryAddress);
    printf("\n\tFat Memory Size  : %d", &FatMemorySize );

    
    DISK disk;
    /*
    if (!DISK_Initialize(&disk, bootDrive))
    {
        printf("Disk init error\r\n");
        goto end;
    }*/


   

  end();
/*
end:
    for (;;);*/
}

void end() {
    for(;;);
}