bits 16

section .text
extern _cstart_
global entry

entry:
    cli
    mov ax, ds
    mov ss, ax
    mov sp, 0
    mov bp, sp
    sti

	;extpect drive number in dl. Send it as argument to cstart
	xor dh, dh
	push dx
	call _cstart_

	cli
	hlt

section .data
    ; Your data declarations go here

section .bss
    ; Your uninitialized data (BSS) declarations go here

