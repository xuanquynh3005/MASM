extrn GetStdHandle	:PROC
extrn WriteFile		:PROC
extrn ReadFile		:PROC
extrn ExitProcess	:PROC

.data
	mess1	db	"Input: ", 0h
	mess2	db	"Output: ", 0h

.data?
	inp		db	100 dup(?)
	nByte	db	?

.code
main PROC
	mov		rbp, rsp
	sub		rbp, 28h
	xor		rbx, rbx
	mov		rcx, -11
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset mess1
	mov		r8, sizeof mess1
	mov		r9, offset nByte
	mov		[rsp+20h], rbx
	call	WriteFile

	mov		rcx, -10			;STD_INPUT_HANDLE
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset inp
	mov		r8, 100
	mov		r9, offset nByte
	mov		[rsp+20h], rbx
	call	ReadFile

	mov		rcx, -11
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset mess2
	mov		r8, sizeof mess2
	mov		r9, offset nByte
	mov		[rsp+20h], rbx
	call	WriteFile
	
	mov		rcx, -11
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset inp
	mov		r8, sizeof inp
	mov		r9, offset nByte
	mov		[rsp+20h], rbx
	call	WriteFile

	mov		rcx, 0
	call	ExitProcess

main ENDP
END

