.386
.model flat, stdcall
option casemap: none

include D:\masm32\include\kernel32.inc 
include D:\masm32\include\masm32.inc 
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\masm32.lib

.data
	strg	db	256 dup(?)
	
.code
main PROC
	push	256
	push	offset	strg
	call	StdIn

	push	offset	strg
	call	reverse

	push	offset	strg
	call	StdOut

	push	0
	call	ExitProcess
main ENDP

reverse PROC
	push 	ebp
	mov		ebp, esp			
	push	eax
	push	ebx
	mov		eax, [ebp + 08h]		;eax = offset input
	mov		ebx, [ebp + 08h]		;ebx = offset output
	mov		edi, 0				
	mov		esi, 0				
	push	0h

	process:
		mov		edx, 0			
		mov		dl, byte ptr[eax + esi]
		cmp		dl, 0h
		jz		pop_string
		push	edx
		inc		esi
		jmp		process

	pop_string:
		pop		edx
		cmp		dl, 0h
		jz		break
		mov		byte ptr[ebx + edi], dl
		inc		edi
		jmp		pop_string

	break:
		mov		byte ptr[ebx + edi], 0
		pop		ebx
		pop		eax
		pop		ebp
		ret		8
reverse ENDP

END main


