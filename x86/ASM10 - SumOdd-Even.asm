.386
.model flat, stdcall
option casemap:none

include D:\masm32\include\kernel32.inc 
include D:\masm32\include\masm32.inc 
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\masm32.lib

.data
	num			db	30 dup(?)
	index		db	35 dup(?)
	n			dd	0
	eve			dd	0
	odd			dd	0
	sum_even	db	"Tong chan = ", 0
	sum_odd		db	"Tong le = ", 0
	newl		db	0Ah, 0
	bspace		db	20h, 0

.code
main PROC
	push	5
	push	offset num
	call	StdIn

	push	offset num
	call	atoi
	mov		n, eax

	find:
		cmp		n, 0
		jz		done
		push	30
		push	offset num
		call	StdIn
		dec		n
		push	offset num			;str
		call	atoi
		mov		ebx, eax			;ebx = number
		mov		ecx, 2
		xor		edx, edx
		div		ecx
		cmp		edx, 1
		jz		n_odd
		cmp		edx, 0
		jl		n_even

	n_even:
		add		eve, ebx
		jmp		find

	n_odd:
		add		odd, ebx
		jmp		find

	done:
		push	offset sum_odd
		call	StdOut
		push	odd
		push	offset index
		call	itoa
		push	offset index
		call	StdOut

		push	offset newl
		call	StdOut

		push	offset sum_even
		call	StdOut
		push	eve
		push	offset index
		call	itoa
		push	offset index
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