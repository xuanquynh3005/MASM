.386
.model flat, stdcall
option casemap:none

include D:\masm32\include\kernel32.inc 
include D:\masm32\include\masm32.inc 
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\masm32.lib

.data
	mode	db "1. Cong", 0Ah, "2. Tru", 0Ah, "3. Nhan", 0Ah, "4. Chia", 0
	text1	db "Number 1: ", 0
	text2	db "Number 2: ", 0
	plus	db " + ", 0
	minus	db " - ", 0
	multi	db " * ", 0
	divide	db " / ", 0
	equal	db " = ", 0
	input	db 3 dup(?)
	num1	db 30 dup(?)
	num2	db 30 dup(?)
	ans1	db 31 dup(?)
	n		dd 0
	n1		dd 0
	n2		dd 0
	ans		dd 0
	bspace	db 20, 0
	nline	db 0Ah, 0Dh, 0

.code
main PROC
	push	offset mode
	call	StdOut

	push	offset nline
	call	StdOut

	push	3
	push	offset input
	call	StdIn
	
	push	offset input
	call	atoi
	mov		n, eax					

	push	offset text1
	call	StdOut
	
	push	30
	push	offset num1
	call	StdIn
	
	push	offset num1
	call	atoi
	mov		n1, eax

	push	offset text2
	call	StdOut
	
	push	30
	push	offset num2
	call	StdIn
	
	push	offset num2
	call	atoi
	mov		n2, eax

	mov		ecx, n
	
	cmp		ecx, 1					
	jz		Plus
	
	cmp		ecx, 2
	jz		Minus
	
	cmp		ecx, 3
	jz		Multi
	
	cmp		ecx, 4
	jz		Divide
	
	jmp		Done

	Plus:
		push	offset num1
		call	StdOut

		push	offset plus
		call	StdOut

		push	offset num2
		call	StdOut

		push	offset equal
		call	StdOut

		mov		edx, 0
		mov		eax, 0
		mov		ebx, 0

		mov		eax, n1					
		mov		ebx, n2					
		add		eax, ebx

		mov		ans, eax
		jmp		Done

	Minus:
		push	offset num1
		call	StdOut

		push	offset minus
		call	StdOut

		push	offset num2
		call	StdOut

		push	offset equal
		call	StdOut

		mov		edx, 0
		mov		eax, 0
		mov		ebx, 0

		mov		eax, n1					
		mov		ebx, n2					
		sub		eax, ebx

		mov		ans, eax
		jmp		Done

	Multi:
		push	offset num1
		call	StdOut

		push	offset multi
		call	StdOut

		push	offset num2
		call	StdOut

		push	offset equal
		call	StdOut

		mov		edx, 0
		mov		eax, 0
		mov		ebx, 0

		mov		eax, n1					
		mov		ebx, n2					
		mul		ebx

		mov		ans, eax
		jmp		Done

	Divide:
		push	offset num1
		call	StdOut

		push	offset divide
		call	StdOut

		push	offset num2
		call	StdOut

		push	offset equal
		call	StdOut

		mov		edx, 0
		mov		eax, 0
		mov		ebx, 0
		mov		eax, n1					
		mov		ebx, n2					
		div		ebx

		mov		ans, eax
		jmp		Done

	Done:	
		push	ans
		push	offset ans1
		call	itoa

		push	offset ans1
		call	StdOut

		push	0
		call	ExitProcess
main ENDP

atoi PROC
	push	ebp
	mov		ebp, esp
	push	ebx
	mov		ebx, [ebp + 08h]
	mov		edi, 0
	mov		eax, 0	
	mov		esi, 10			
	mov		edx, 0

	atoi_str:
		mov		dl, byte ptr[ebx + edi]	
		sub		dl, 30h		
		add		al, dl	
		inc		edi
		cmp		byte ptr[ebx + edi], 0h
		jz		pop_atoi
		mul		esi
		mov		edx, 0 
		jmp		atoi_str

	pop_atoi:
		pop		ebx
		pop		ebp
		ret		4
atoi ENDP

itoa PROC
	push	ebp
	mov		ebp, esp
	mov		eax, [ebp + 0Ch]
	mov		esi, [ebp + 08h]
	mov		edi, 0
	mov		ebx, 10			
	mov		edx, 0
	push	3Ah

	itoa_str:
		mov		edx, 0
		div		ebx
		add		edx, 30h
		push	edx
		cmp		eax, 0h
		jz		pop_itoa
		jmp		itoa_str

	pop_itoa:
		pop		edx
		cmp		dl, 3Ah
		jz		break
		mov		byte ptr[esi + edi], dl
		inc		edi
		jmp		pop_itoa

	break:
		mov     byte ptr [esi + edi], 0
		pop		ebp
		ret		8
itoa ENDP
END main