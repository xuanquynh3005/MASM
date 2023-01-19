.386
.model flat, stdcall
option casemap:none

include D:\masm32\include\kernel32.inc 
include D:\masm32\include\masm32.inc 
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\masm32.lib

.data
	message db 40 dup(?)

.code
main PROC
	push	40
	push	offset message
	call	StdIn

	push	offset message
	call	StdOut

	invoke	ExitProcess, 0
main ENDP
END main