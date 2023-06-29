ENTRY(entry)
OUTPUT_FORMAT("binary")
OUTPUT_ARCH(i386)

SECTIONS
{
    . = 0x0;      /* Set the initial offset to 0 */
    .text :       /* Code section */
    {
        *(.text)
    }

    .data :       /* Data section */
    {
        *(.data)
    }

    .bss :        /* BSS section */
    {
        *(.bss)
    }

    /* Define the stack section 
    stack_start = 0x200;   Define the stack starting address 
    stack_length = 0x400;  Define the stack size 
    .stack ALIGN(4) :
    {
        PROVIDE(_stack_start = .);
        *(.stack)
        PROVIDE(_stack_end = .);
    } > RAM */
}

