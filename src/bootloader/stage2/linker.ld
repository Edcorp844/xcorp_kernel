ENTRY(_start)
OUTPUT_FORMAT("binary")
OUTPUT_ARCH(i386)

SECTIONS
{
        . = 0x0;          /* Set the initial offset to 0 */

        /* Code section */
        .text :
        {
                *(.text)
        }

        /* Data section */
        .data :
        {
                *(.data)
        }

        /* BSS section */
        .bss :
        {
                *(.bss)
        }

		/* Stack section */
		.stack 0x200 :    /* Define the stack address at 0x200 */
		 {
			 /* No specific content for stack section */
		}

}
