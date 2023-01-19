extrn GetStdHandle	:PROC
extrn WriteFile		:PROC
extrn ReadFile		:PROC
extrn ExitProcess	:PROC

.data
	num1	db	100 dup(?)
	num2	db	100 dup(?)
	ans1	db	100 dup(?)
	nByte	dd	?

.code
main PROC
	mov		rbp, rsp
	sub		rsp, 28h

	xor		rbx, rbx
	mov		rcx, -10
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset num1
	mov		r8, 100
	mov		r9, offset nByte
	mov		[rbp + 20h], rbx
	call	ReadFile
	
	xor		rbx, rbx
	mov		rcx, -10
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset num2
	mov		r8, 100
	mov		r9, offset nByte
	mov		[rbp + 20h], rbx
	call	ReadFile

	mov		rbx, offset num1
	call	atoi
	mov		r12, rax

	mov		rbx, offset num2
	call	atoi
	mov		r13, rax

	add		r12, r13				;r12 = r12 + r13	
	
	mov		r14, r12				;r14 = sum 
	mov		r15, offset ans1	
	call	itoa

	xor		rbx, rbx
	mov		rcx, -11
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset ans1
	mov		r8, 100
	mov		r9, offset nByte
	mov		[rbp + 20h], rbx
	call	WriteFile

	mov		rcx, 0
	call	ExitProcess
main ENDP

atoi PROC								;rbx = &string
	push	rbp
	mov		rbp, rsp
	push	rbx
	xor		rsi, rsi
	xor		rax, rax
	xor		rdx, rdx
	mov		rdi, 10

	atoi_str:
		mov		dl, byte ptr [rbx + rsi]
		sub		dl, 30h
		add		al, dl
		inc		rsi
		cmp		byte ptr [rbx + rsi], 0Dh
		jz		pop_str
		mul		rdi
		xor		edx, edx
		jmp		atoi_str

	pop_str:
		pop		rbx
		mov		rbp, rsp
		pop		rbp
		ret
atoi ENDP

itoa PROC								;r14 = sum, r15 = offset ouput_string
		push	rbp
		mov		rbp, rsp
		mov		rax, r14				;rax = sum
		mov		rsi, r15
		mov		rdi, 0
		mov		rbx, 10			
		mov		rdx, 0
		push	3Ah

	itoa_str:
		mov		rdx, 0
		div		rbx
		add		rdx, 30h
		push	rdx
		cmp		rax, 0h
		jz		pop_itoa
		jmp		itoa_str

	pop_itoa:
		pop		rdx
		cmp		dl, 3Ah
		jz		break
		mov		byte ptr[rsi + rdi], dl
		inc		rdi
		jmp		pop_itoa

	break:
		mov     byte ptr [rsi + rdi], 0
		pop		rbp
		ret		
itoa ENDP		
END