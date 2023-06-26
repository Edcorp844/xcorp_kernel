org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

start:
        jmp main

;function to print string on to the screen
; params:
;       ds:si point to string
;
puts:
        ;save registers we will modify
        push si
        push ax

.loop:
        lodsb           ;loads next character in al
        or al, al       ;check if next charater is null
        jz .done

        mov ah, 0x0e
        mov bh, 0
        int 0x10

        jmp .loop

.done:
        pop ax
        pop si
        ret


main:
        ;set up data segments
        mov ax, 0 ;cant write directly to ds/es
        mov ds, ax
        mov es, ax

        ;set up stack
        mov ss, ax
        mov sp, 0x7C00 ;stack grows downwards

        ;print msg on the screen
        mov si, hello_msg
        call puts

        hlt

.halt:
        jmp .halt

hello_msg: db 'Xcorp os', ENDL, 0

times 510-($-$$) db 0
dw 0AA55h
