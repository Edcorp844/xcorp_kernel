org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

;FAT12 header
jmp short start
nop

bdb_oem:			db 'MSWIN4.1'	 ;8 bytes
bdb_bytes_per_sector:		dw 512
bdb_sectors_per_cluster:	db 1
bdb_reserved_sectors:		dw 1
bdb_fat_count:			db 2
bdb_dir_entries_count:		dw 0E0h
bdb_total_sectors:		dw 2880		;2880 * 512 = 1.44mb
bdb_media_descriptor_type:	db 0F0h		;indicates 3.5 inch floppy disk
bdb_sectors_per_fat:		dw 9		;9 sectoes per fat
bdb_sectors_per_track:		dw 18
bdb_heads:			dw 2
bdb_hidden_sectors:		dd 0
bdb_large_sectors:		dd 0

;Extended boot record
ebr_drive_number: 		db 0 			;0x00 floppy, 0x80 hdd, value is incorrect if device is changed
				db 0 			;reserved
ebr_signature:			db 29h
ebr_volume_id:			db 12h, 34h, 54h, 78h 	;Serial number...value doesn't even matter
ebr_volume_label:		db 'XCORP    OS'	;11 bytes padded with spaces
ebr_system_id:			db 'FAT12   '		;8 bytes also padded with spaces

;code goes here


start:
	;set up data segments
	mov ax, 0 	;cant write directly to ds/es
	mov ds, ax
	mov es, ax

	;set up stack
	mov ss, ax
	mov sp, 0x7C00 	;stack grows downwards

	;some BIOS'es might start us at 07C0:0000 instead of 0000:07C0, make sure we are in the expected location
	push es
	push word .after
	retf

.after:
	;read some thing from the disk
	;set the DL to drive number
	mov [ebr_drive_number], dl

	;print loading msg on the screen
	mov si, msg_loading
	call puts

	;read drive parameters(sectors per track and head) you don't wanna rely on the disk...than the bois
	;note: This cannot be hard coded
	push es
	mov ah, 08h
	int 13h
	jc floppy_error
	pop es
	and cl, 0x3F				;remove 2 top bits
	xor ch, ch
	mov [bdb_sectors_per_track], cx		;sector count

	inc dh
	mov [bdb_heads], dh			;head count

	;read FAT root directory
	mov ax, [bdb_sectors_per_fat]		;compare LBA for root directory = reserved + fats * sectors per fat
	mov bl, [bdb_fat_count]
	xor bh, bh
	mul bx					;dx:ax = (fats * sectors per fat)
	add ax, [bdb_reserved_sectors]		;LBA rootdirectory
	push ax

	;compute size of root directory = (32 * number_of_entries)/ bytes per sector
	mov ax, [bdb_sectors_per_fat]
	shl ax, 5				;ax *= 32
	xor dx, dx				;dx = 0
	div word [bdb_bytes_per_sector]		;number of sectors we need to read


	test dx, dx				;if dx != 0, add 1
	jz .root_dir_after
	inc ax					;division reminder != 0, add 1
						;this means we have a sector only partialyy filed with entries

.root_dir_after:
	;read root dir
	mov cl, al				;cl = number of sectors to read = size of root directory
	pop ax					;ax = LBA of root directory
	mov dl, [ebr_drive_number]		;dl = drive number..we saved it previously
	mov bx, buffer				;es:bx = buffer
	call read_disk

	;search for kernel.bin through the directory entries
	xor bx, bx
	mov di, buffer
.search_kernel:
	mov si, file_kernel_bin
	mov cx, 11				;move up 11 characters to compare in cx
	push di
	repe cmpsb
	pop di
	je .found_kernel
	add di, 32
	inc bx
	cmp bx, [bdb_dir_entries_count]
	jl .search_kernel

	;kernel not found
	jmp kernel_not_found_error

.found_kernel:
	;di  should contain the address of the entry
	mov ax, [di + 26]			;first logical cluster (offset = 26)
	mov [kernel_cluster], ax

	;load FAT from disk into memory
	mov ax, [bdb_reserved_sectors]
	mov bx, buffer
	mov cl, [bdb_sectors_per_fat]
	mov dl, [ebr_drive_number]
	call read_disk

	;read cluster and process FAT chain
	mov bx, KERNEL_LOAD_SEGMANT
	mov es, bx
	mov bx, KERNEL_LOAD_OFFSET

.load_kernel_loop:
	;read next cluster
	mov ax, [kernel_cluster]

	;THIS WAS HARD CORDING VALUE...I'll need to fix this in the future to avoid problems
	add ax, 31


	mov cl, 1
	mov dl, [ebr_drive_number]
	call read_disk

	add bx, [bdb_bytesper_sector]
	;compute location of next cluster
	mov ax, [kernel_cluster]
	mov cx, 3
	mul cx
	mov cx, 2
	div cx					;ax = index of entry in FAT. dx = cluster mod 2
	mov si, buffer
	add si, ax
	mov ax, [ds:si]				;read entry from FAt table at ax

	or dx,dx
	jz .even

.odd:
	shr ax, 4
	jmp .next_cluster_after

.even:
	and ax, 0x0FFF

.next_cluster_after:
	cmp ax, 0x0FF8				;end of chain
	jae .read_finish

	mov [kernel_cluster], ax
	jmp .load_kernel_loop
.read_finish:
	;jum to our kernel
	mov dl, [ebr_drive_number]		;boot device in dl


	mov ax, KERNEL_LOAD_SEGMENT		;set segment registers
	mov ds, ax
	mov es, ax

	jmp KERNEL_LOAD_SEGMANT:KERNEL_LOAD_OFFSET

	jmp wait_key_and_reboot			;should never happen

	cli
	hlt

;error handlers
floppy_error:
	mov si, msg_read_failed
	call puts
	jmp wait_key_and_reboot

kernel_not_found_error:
	mov si, msg_not_kernel_found_error
	call puts
	jmp wait_key_and_reboot

wait_key_and_reboot:
	mov ah, 0
	int 16h		;waits for key press
	jmp 0FFFFh:0	;jump to the BIOS beginning...should reboot

.halt:
	cli		;disable interupts: This way CPU can't get out of "halt" state
	jmp .halt


;function to print string on to the screen
; params:
;       ds:si point to string
;
puts:
        ;save registers we will modify
        push si
        push ax
	push bx

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

;Disk routines
;conversts Logical Block Address (LBA) to CHS address
;parameter:
;	- ax : lba address
;Returns:
;	- cx [bits 0 - 5] : sector number
;	- cx [bits 6 -15] : cylinder
;	- dh :	head

lba_to_chs:
	;store the contents of ax and dx , the registers we are going to use
	push ax
	push dx

	xor dx, dx				;dx = 0
	div word [bdb_sectors_per_track]	;ax = lba / sectors per track
						;dx = lba % sectors per track
	inc dx					;dx = (lba % sectors per track + 1) = sector
	mov cx, dx				;cx = sector

	xor dx, dx				;dx = 0
	div word [bdb_heads]			;dx = (LBA / sectorsPerTrack) / heads = cylinder
						;ax = (lBA / sectorsPerTrack) % heads = head
	mov dh, dl				;dh = head
	mov ch, al				;ch = cylinder (lower 8 bits)
	shl ah, 6
	or cl, ah				;put 2 upper bitsof the cylinder into cl

	;Restore the contents of the registers, but since we cant push 16 bit regs onto the stack,we push the entire dx and we only pop dl
	pop ax
	mov dl, al				;restore dl
	pop ax
	ret

;reads sectors from disk
;parameters:
;	- ax : LBA adress
;	- cl : number of sectors to read (upto 128)
;	- dl : drive number
;	- es : bx : where to store read data
read_disk:
	;save registers we will modify
	push ax
	push bx
	push cx
	push dx
	push di

	push cx			;tempolarily save cl (number of sectors to read
	call lba_to_chs		;compute CHS
	pop ax			;AL = number of sectores to read

	mov ah, 02h
	mov di, 3		;retry count

.retry:
	pusha			;save all registers..we dont know what bios modifies
	stc			;Setr carry flag, some BIOS'es dont set it
	int 13h			;carry flag cleared = success
	jnc .done		;jump if carry not set

	;disk failed
	popa
	call disk_reset

	dec di
	test di, di
	jnz .retry

.fail:
	;all atempts failed
	jmp floppy_error

.done:
	popa

	;restore registers modified
	pop di
	pop dx
	pop cx
	pop bx
	pop ax

;resetes disk controler
;parameters:
;	dl : drive number
disk_reset:
	pusha
	mov ah, 0
	stc
	int 13h
	jc floppy_error
	popa
	ret

;string lables
msg_loading: db 'Xcorp is Loading components...', ENDL, 0
msg_read_failed: db 'Failed to read disk', ENDL, 0
msg_kernel_not_found_error: db 'Kernel.bin not found', ENDL, 0
file_kernel_bin: db 'KERNEL  BIN'
kernel_cluster:	dw 0
KERNEL_LOAD_SEGMENT equ 0x2000
KERNEL_LOAD_OFFSET  equ 0

;padding the  510 bytes with 0's
times 510-($-$$) db 0
dw 0AA55h	;adding aa55 to make 51bytes with tell the bois this is the bootsector

buffer:
