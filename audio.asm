[bits 32]

; void __attribute__((cdecl)) i686_Audio_Play(uint8_t* audioData, uint32_t audioLength);
global i686_Audio_Play

i686_Audio_Play:
    push ebp             ; Save old call frame
    mov ebp, esp         ; Initialize new call frame

    ; Set up the sound card
    mov ax, 0x0003      ; Set video mode to 3 (text mode)
    int 0x10            ; Call BIOS interrupt

    mov dx, 0x388       ; Set port address for the sound card
    mov al, 0xB6        ; Send command to enable sound
    out dx, al

    ; Play audio
    mov ecx, [ebp + 8]  ; audioLength parameter
    mov esi, [ebp + 12] ; audioData parameter

play_audio:
    mov al, byte [esi]  ; Load byte from audio data
    out dx, al          ; Send byte to the sound card
    add esi, 1          ; Increment pointer to audio data
    loopnz play_audio   ; Repeat until ecx becomes zero

    ; Clean up
    mov dx, 0x388       ; Set port address for the sound card
    xor al, al          ; Send command to disable sound
    out dx, al

    ; Restore old call frame
    mov esp, ebp
    pop ebp
    ret





    push ebp             ; Save old call frame
    mov ebp, esp         ; Initialize new call frame

    ; Set up the sound card
    mov ax, 0x0003      ; Set video mode to 3 (text mode)
    int 0x10            ; Call BIOS interrupt

    mov dx, 0x388       ; Set port address for the sound card
    mov al, 0xB6        ; Send command to enable sound
    out dx, al

    ; Play audio
    mov ecx, [ebp + 8]  ; audioLength parameter
    mov esi, [ebp + 12] ; audioData parameter

play_audio:
    mov al, byte [esi]  ; Load byte from audio data
    out dx, al          ; Send byte to the sound card
    add esi, 1          ; Increment pointer to audio data
    loopnz play_audio   ; Repeat until ecx becomes zero

    ; Clean up
    mov dx, 0x388       ; Set port address for the sound card
    xor al, al          ; Send command to disable sound
    out dx, al

    ; Restore old call frame
    mov esp, ebp
    pop ebp
    ret



    section .data
    note_freq equ 440 ; Bell sound frequency (440Hz)
    sample_rate equ 44100 ; Sample rate (44100Hz)
    period equ 1000000 / sample_rate ; Period for one sample
    sample_count equ sample_rate ; Number of samples to play

section .text
global _start

_start:
    ; Initialize audio hardware
    ; Place your code here to set up the audio hardware

    ; Calculate the increment value for generating the bell sound frequency
    mov ebx, note_freq
    mov eax, period
    mul ebx
    mov esi, eax ; Increment value for frequency

    ; Play the bell sound
    mov ecx, sample_count
play

section .data
    ; Define the required constants
    FAT12_BYTES_PER_SECTOR    equ 512
    FAT12_BOOT_SECTOR_OFFSET  equ 0x0
    FAT12_SECTOR_SIZE_OFFSET  equ 0x0B
    FAT12_SECTORS_PER_CLUSTER equ 0x0D
    FAT12_RESERVED_SECTORS    equ 0x0E
    FAT12_NUMBER_OF_FATS      equ 0x10
    FAT12_ROOT_ENTRIES        equ 0x11
    FAT12_TOTAL_SECTORS       equ 0x13
    FAT12_SECTORS_PER_FAT     equ 0x16
    FAT12_SECTORS_PER_TRACK   equ 0x18
    FAT12_NUMBER_OF_HEADS     equ 0x1A

section .text
global x86_Disk_GetDriveParams

x86_Disk_GetDriveParams:
    push ebp
    mov ebp, esp

    ; Get the function arguments
    mov eax, [ebp + 8]     ; disk->id
    mov ebx, [ebp + 12]    ; &driveType
    mov ecx, [ebp + 16]    ; &cylinders
    mov edx, [ebp + 20]    ; &sectors
    mov edi, [ebp + 24]    ; &heads

    ; Calculate the address of the boot sector
    mov ebx, eax
    shl ebx, 6
    add ebx, eax

    ; Read the number of sectors per cluster
    mov al, [ebx + FAT12_SECTORS_PER_CLUSTER]
    mov [ecx], al

    ; Read the number of reserved sectors
    mov ax, [ebx + FAT12_RESERVED_SECTORS]
    mov [edx], ax

    ; Read the number of FATs
    mov al, [ebx + FAT12_NUMBER_OF_FATS]
    mov [edi], al

    ; Read the number of root directory entries
    mov ax, [ebx + FAT12_ROOT_ENTRIES]
    mov [ecx + 2], ax

    ; Read the total number of sectors
    mov ax, [ebx + FAT12_TOTAL_SECTORS]
