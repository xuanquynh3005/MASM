extrn GetStdHandle	:PROC
extrn WriteFile		:PROC
extrn ExitProcess	:PROC

.data
	msg		db	"Hello World", 0Ah, 0h

.data?
	nByte	dd ?

.code 
main PROC
	mov		rbp, rsp
	sub		rsp, 28h			;shadow space + align

	mov		rcx, -11			;STD_OUPUT_HANDLE
	call	GetStdHandle		;return handle rax
	xor		rbx, rbx
	mov		rcx, rax		
	mov		rdx, offset msg		
	mov     r8, sizeof msg		;str length
	mov		r9, offset nByte	;return number of bytes
	mov		[rsp + 20h], rbx	
	call	WriteFile

	mov		rcx, 0
	call	ExitProcess

main ENDP
END