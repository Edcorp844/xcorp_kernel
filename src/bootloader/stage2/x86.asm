section .text align=4
global x86_video_writeCharTeletype

x86_video_writeCharTeletype:
    push bp                  ; Save old call frame
    mov bp, sp               ; Initialize new call frame

    ; Save bx
    push bx

    ; [bp + 0] - return address (small memory model => 2 bytes)
    ; [bp + 2] - first argument (character): bytes are converted to words (you can't push a single byte on the stack)
    ; [bp + 4] - second argument (page)
    mov ah, 0Eh
    mov al, [bp + 2]
    mov bh, [bp + 4]

    int 10h

    ; Restore bx
    pop bx

    ; Restore old frame
    mov sp, bp
    pop bp
    ret

section .data align=4
section .bss align=4
section .stack align=4
