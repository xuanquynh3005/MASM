.386
.model flat, stdcall
option casemap:none

include D:\masm32\include\kernel32.inc 
include D:\masm32\include\masm32.inc 
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\masm32.lib

.data
	ar db 40 dup(?)

.code
main PROC
	push	40
	push	offset ar
	call	StdIn
	
	push	offset ar
	call	Uppercase

	push	offset ar
	call	StdOut

	push	0
	call	ExitProcess
main ENDP

Uppercase PROC
	push	ebp
	mov		ebp, esp
	push	eax
	mov		eax, [ebp + 08h]
	mov		esi, 0

	upper:
		cmp		byte ptr[eax + esi], 0
		jz		pop_str
		cmp		byte ptr[eax + esi], 'a'
		jl		return
		cmp		byte ptr[eax + esi], 'z'
		jg		return
		sub		byte ptr[eax + esi], 20h

	return:
		inc		esi
		jmp		upper

	pop_str:
		pop		eax
		pop		ebp
		ret		4
Uppercase ENDP
END main