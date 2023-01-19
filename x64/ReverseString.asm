extrn GetStdHandle	:PROC
extrn WriteFile		:PROC
extrn ExitProcess	:PROC
extrn ReadFile		:PROC

.data
	inp		db	100 dup(?)
	nByte	db	?

.code
main PROC
	mov		rbp, rsp
	sub		rsp, 28h

	xor		rbx, rbx
	mov		rcx, -10		;STD_INPUT_HANDLE
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset inp
	mov		r8, 100
	mov		r9, offset nByte
	mov		[rsp + 20h], rbx
	call	ReadFile

	mov		r12, offset	inp
	push	r12
	call	Reverse

	xor		rbx, rbx
	mov		rcx, -11		;STD_OUTPUT_HANDLE
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset inp
	mov		r8, 100
	mov		r9, offset nByte
	mov		[rsp + 20h], rbx
	call	WriteFile

	mov		rcx, 0
	call	ExitProcess

main ENDP

Reverse PROC
	push	rbp
	mov		rbp, rsp
	push	rax
	push	rbx
	mov		rax, [rbp + 10h]		;rax = offset input
	mov		rbx, [rbp + 10h]	
	mov		rsi, 0
	mov		rdi, 0

	process:
		xor		rdx, rdx
		mov		dl, byte ptr[rax + rsi]
		cmp		dl, 0Dh
		jz		pop_str
		push	rdx
		inc		rsi
		jmp		process

	pop_str:
		pop		rdx
		cmp		dl, 0h
		jz		break
		mov		byte ptr [rbx + rdi], dl
		inc		rdi
		jmp		pop_str

	break:
		mov		word ptr[rbx + rdi], 0A0Dh
		pop		rbx
		pop		rax	
		mov		rsp, rbp
		pop		rbp
		ret	
Reverse ENDP
END

