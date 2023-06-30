section .entry align=4
extern _cstart_
global _start

_start:
    cli                  ; Disable interrupts
    mov ax, cs
    mov ds, ax           ; Set data segment to code segment
    mov ss, ax           ; Set stack segment to code segment
    mov sp, stack_start  ; Set stack pointer to stack start address
    sti                  ; Enable interrupts

    ; Call your function here
    xor dh, dh
    push dx
    call _cstart_

    cli                  ; Disable interrupts
    hlt                  ; Halt the system

section .text align=4
section .data align=4
section .bss align=4
section .stack align=4

stack_start equ 0x200    ; Define the stack starting address
stack_length equ 0x400   ; Define the stack size

