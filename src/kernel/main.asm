org 0x0
bits 16

%define ENDL 0x0D, 0x0A

start:
        ;print msg on the screen
        mov si, hello_msg
        call puts

.halt:
	cli
        hlt


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

hello_msg: db 'Xcorp os', ENDL, 0

