global i686_outb
i686_outb:
    [bits 32]
    mov dx, [esp + 4]
    mov al, [esp + 8]
    out dx, al
    ret

global i686_inb
i686_inb:
    [bits 32]
    mov dx, [esp + 4]
    xor eax, eax
    in al, dx
    ret

global i686_Panic
i686_Panic:
    cli
    hlt

global crash_me
crash_me:
    ; div by 0
    ; mov ecx, 0x1337
    ; mov eax, 0
    ; div eax
    int 0x80
    ret

;
;The next this code here can bring problems any time
;
%macro LinearToSegOffset 4
    [bits 32]
    mov %3, %1      ; linear address to eax
    shr %3, 4
    mov %2, %4
    mov %3, %1      ; linear address to eax
    and %3, 0xf
%endmacro

%macro i686_EnterRealMode 0
    [bits 32]
    jmp dword 18h:.pmode16         ; 1 - jump to 16-bit protected mode segment

.pmode16:
    [bits 16]
    ; 2 - disable protected mode bit in cr0
    mov eax, cr0
    and al, ~1
    mov cr0, eax

    ; 3 - jump to real mode
    jmp 0:0x0000
%endmacro

%macro i686_EnterProtectedMode 0
    cli

    ; 4 - set protection enable flag in CR0
    mov eax, cr0
    or al, 1
    mov cr0, eax

    ; 5 - far jump into protected mode
    jmp dword 08h:.pmode

.pmode:
    ; we are now in protected mode!
    [bits 32]

    ; 6 - setup segment registers
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
%endmacro


global i686_Disk_GetDriveParams
i686_Disk_GetDriveParams:
    [bits 32]

    ; make new call frame
    push ebp             ; save old call frame
    mov ebp, esp         ; initialize new call frame

    i686_EnterRealMode

    [bits 16]

    ; save regs
    push es
    push bx
    push esi
    push edi

    ; call int13h
    mov dl, byte [bp + 8]   ; dl - disk drive
    mov ah, 08h
    xor di, di              ; es:di - 0000:0000
    mov es, di
    stc
    int 13h

    ; out params
    mov eax, 1
    sbb eax, 0

    ; drive type from bl
    mov [ebp + 12], bl

    ; cylinders
    mov bl, ch              ; cylinders - lower bits in ch
    mov bh, cl              ; cylinders - upper bits in cl (6-7)
    shr bh, 6
    inc bx

    mov [ebp + 16], bx

    ; sectors
    xor ch, ch              ; sectors - lower 5 bits in cl
    and cl, 3Fh

    mov [ebp + 20], cx

    ; heads
    mov cl, dh              ; heads - dh
    inc cx

    mov [ebp + 24], cx

    ; restore regs
    pop edi
    pop esi
    pop bx
    pop es

    ; return

    push eax

    i686_EnterProtectedMode

    [bits 32]

    pop eax

    ; restore old call frame
    mov esp, ebp
    pop ebp
    ret

global i686_Disk_Reset
i686_Disk_Reset:
    [bits 32]

    ; make new call frame
    push ebp             ; save old call frame
    mov ebp, esp         ; initialize new call frame

    i686_EnterRealMode

    mov ah, 0
    mov dl, byte [ebp + 8]   ; dl - drive
    stc
    int 13h

    mov eax, 1
    sbb eax, 0           ; 1 on success, 0 on fail

    push eax

    i686_EnterProtectedMode

    pop eax

    ; restore old call frame
    mov esp, ebp
    pop ebp
    ret

global i686_Disk_Read
i686_Disk_Read:
     [bits 32]

    ; make new call frame
    push ebp             ; save old call frame
    mov ebp, esp         ; initialize new call frame

    i686_EnterRealMode

    ; save modified regs
    push ebx
    push es

    ; setup args
    mov dl, byte [ebp + 8]   ; dl - drive

    mov ch, byte [ebp + 12]  ; ch - cylinder (lower 8 bits)
    mov cl, byte [ebp + 13]  ; cl - cylinder to bits 6-7
    shl cl, 6

    mov al, byte [ebp + 16]  ; al - sector to bits 0-5
    and al, 3Fh
    or cl, al

    mov dh, byte [ebp + 20]  ; dh - head

    mov al, byte [ebp + 24]  ; al - count

    LinearToSegOffset [bp + 28], es, ebx, bx

    ; call int13h
    mov ah, 02h
    stc
    int 13h

    ; set return value
    mov eax, 1
    sbb eax, 0           ; 1 on success, 0 on fail

    ; restore regs
    pop es
    pop ebx

    push eax

    i686_EnterProtectedMode

    pop eax

    ; restore old call frame
    mov esp, ebp
    pop ebp
    ret

;timer_wait(int seconds);
global timer_wait
timer_wait:
    ;Prologue
    push ebp
    mov ebp, esp
    
    ;Calculate the number of iterations needed
    mov eax, 1193180    ; Set divisor value
    mov edx, 0          ; Clear edx for division
    div eax             ; Divide by 18.2 (approximately)
    mov ecx, eax        ; Store the number of iterations
    
    ;Wait loop
loop_start:
    mov eax, ecx        ; Restore the number of iterations
delay_loop:
    dec eax             ; Decrement the iteration counter
    cmp eax, 0          ; Compare it with 0
    jne delay_loop      ; Jump back if not zero
    
    ;Decrement the counter
    dec ecx
    cmp ecx, 0          ; Compare it with 0
    jne loop_start      ; Jump back if not zero
    
    ;Epilogue
    mov esp, ebp
    pop ebp
    ret
