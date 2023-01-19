.386
.model flat, stdcall
option casemap: none

include D:\masm32\include\kernel32.inc 
include D:\masm32\include\masm32.inc 
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\masm32.lib

.data
	num1	db	30 dup(?)
	num2	db	30 dup(?)
	ans		dd	0
	n1		dd	0
	n2		dd	0
	ans1	db	32 dup(?)


.code
main PROC
	push	30
	push	offset num1
	call	StdIn

	push	30
	push	offset num2
	call	StdIn

	push	offset num1
	call	atoi				;convert string to number
	mov		n1, eax

	push	offset num2
	call	atoi
	mov		n2, eax

	mov		ebx, 0
	mov		eax, n1
	mov		ebx, n2
	add		eax, ebx				

	mov		ans, eax

	push	ans
	push	offset ans1
	call	itoa				;convert number to string

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