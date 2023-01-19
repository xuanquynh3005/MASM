.386
.model flat, stdcall
option casemap: none

include D:\masm32\include\kernel32.inc 
include D:\masm32\include\masm32.inc 
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\masm32.lib

.data
	strg		db	100 dup(?)
	substrg		db	10 dup(?)
	entr		db	0Ah, 0
	count		dd	0
	count1		db	100 dup(?)
	addrs		db	100 dup(?)
	dem			dd	0


.code	
main PROC
	push	100
	push	offset	strg
	call	StdIn

	push	10
	push	offset	substrg
	call	StdIn

	push	offset	strg
	push	offset	substrg
	call	solve

	push	count
	push	offset	count1					;So lan xuat hien
	call	itoa
	
	push	offset count1
	call	StdOut

	push	offset entr						;xuong dong
	call	StdOut

	push	offset addrs					;mang chua vi tri bat dau cua xau con
	call	StdOut

	push	0
	call	ExitProcess
main ENDP

solve PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	mov		eax, [ebp + 0Ch]		;xau me
	mov		ebx, [ebp + 08h]		;xau con
	xor		esi, esi
	xor		edi, edi
	
	pro:
		xor		edx, edx
		mov		esi, 0
		mov		dl, byte ptr [eax + edi]
		mov		dh, byte ptr [ebx + esi]
		cmp		dl, 0
		jz		exit
		cmp		dl, dh
		jz		pro2
		inc		edi
		jmp		pro

	pro2: 
		mov		edx, 0
		mov		dl,	byte ptr [eax + edi]
		mov		dh, byte ptr [ebx + esi]
		cmp		dh, 0
		jz		pro3
		inc		edi
		inc		esi
		cmp		dh, dl
		je		pro2
		jmp		pro

	pro3:
		push	eax
		push	ebx
		sub		edi, esi

		push	edi
		push	offset count1
		call	itoa
		pop		ebx
		pop		eax

		push	offset count1
		push	offset	addrs
		call	print
		inc		edi
		push	esi
		mov		esi, count
		inc		esi
		mov		count, esi
		pop		esi
		jmp		pro

	exit:
		pop		ebx
		pop		eax
		pop		ebp
		ret		8
solve ENDP

print PROC
	push	ebp
	mov		ebp, esp
	pushad
	mov		eax, [ebp + 0Ch]		;vi tri dau tien cua xau con
	mov		ebx, [ebp + 08h]		;mang de luu vi tri
	mov		edx, 0
	mov		ecx, dem
	mov		esi, 0

	mov_char:
		mov		dl, byte ptr[eax + esi]
		cmp		dl, 0
		jz		add_space
		mov		byte ptr [ebx + ecx], dl
		inc		ecx
		inc		esi
		jmp		mov_char

	add_space:
		mov		byte ptr [ebx + ecx], 20h
		inc		ecx
		mov		dem, ecx
		popad
		pop		ebp
		ret		8
print ENDP

itoa PROC
	push	ebp
	mov		ebp, esp
	pushad
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
		popad
		pop		ebp
		ret		8
itoa ENDP
END main
