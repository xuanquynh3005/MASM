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
	call	Upper

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

Upper PROC
	push	rbp
	mov		rbp, rsp
	push	rax
	mov		rax, [rbp + 10h]
	xor		rsi, rsi

	process:
		cmp		byte ptr[rax + rsi], 0
		jz		pop_str
		cmp		byte ptr[rax + rsi], 'a'
		jl		return
		cmp		byte ptr[rax + rsi], 'z'
		jg		return
		sub		byte ptr[rax + rsi], 20h

	return:
		inc		rsi
		jmp		process

	pop_str:
		pop		rax
		mov		rbp, rsp
		pop		rbp
		ret
Upper ENDP
END
