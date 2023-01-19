.386
.model flat, stdcall
option casemap:none

include D:\masm32\include\kernel32.inc 
include D:\masm32\include\masm32.inc 
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\masm32.lib

.data
	hello	db "Hello World", 0Ah, 0h

.code
main PROC
	push	30
	push	offset hello
	call	StdOut

	push	0
	call	ExitProcess
main ENDP
END main