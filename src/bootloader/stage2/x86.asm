bits 16

section .text
global x86_video_writeCharTeletype

x86_video_writeCharTeletype:
	push bp
	mov sp, bp

	push bx
	mov ah 0Eh
	mov al, [bp + 2]
	mov bh, [bp + 4]

	int 10h

	pop bx

	mov sp, bp
	pop bp
	ret
