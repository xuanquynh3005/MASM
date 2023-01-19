.386
.model flat, stdcall
option casemap:none

include D:\masm32\include\kernel32.inc 
include D:\masm32\include\masm32.inc 
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\masm32.lib

.data
	n		db 100 dup(?)
	num_n	dd 0
	print0	db '0', 20h, 20h, 0
	print1	db '1', 20h, 20h, 0
	bspace	db 20h, 20h, 0
	s1		db 99 dup(0), 0
	s2		db 99 dup(0), 0
	s3		db 100 dup(0)
	len1	dd 0
	len2	dd 0
	mem		dd 0

.code
main PROC
	push	100
	push	offset n
	call	StdIn

	push	offset n
	call	atoi
	mov		num_n, eax

	cmp		num_n, 0			;if num_n = 0 -> print 0
	jz		print00
	cmp		num_n, 1			;if num_n = 1 -> print 1
	jz		print01
	jmp		print_fibo			;if num_n != 0 && num_n != 1 -> print fibonacci

	print00:
		push	offset print0
		call	StdOut
		jmp		exit

	print01:
		push	offset print1
		call	StdOut
		jmp		exit

	print_fibo:
		push	offset print0				
		call	StdOut

		push	offset print1				
		call	StdOut

		mov		ecx, 2
		mov		eax, num_n
		sub		eax, ecx
		mov		num_n, eax
		mov		eax, 0

		push	edx
		mov		edx, offset s1
		mov		byte ptr [edx], '0'
		mov		edx, offset s2
		mov		byte ptr [edx], '1'
		pop		edx
		jmp		find_fibo

	find_fibo:
		mov		ecx, num_n
		cmp		ecx, 0
		jz		exit
		
		push	offset s1
		call	reverse
		push	offset s2
		call	reverse

		add_pro:
			push	offset s1
			call	len
			mov		len1, eax

			push	offset s2
			call	len
			mov		len2, eax

			mov		eax, len1
			mov		ebx, len2
			cmp		eax, ebx
			jz		jmp1
			cmp		eax, ebx		;len1 < len2
			jl		jmp2
			cmp		eax, ebx		;len1 > len2
			jg		jmp3
		
		next:
			push	offset s1		;chuoi xuat gia tri duoc copy
			push	offset s2		;chuoi duoc copy
			call	copy

			push	offset s2		;chuoi xuat gia tri duoc copy
			push	offset s3		;chuoi duoc copy
			call	copy

			jmp		find_fibo		

		jmp1:
			push	offset s1
			push	offset s2
			push	offset s3
			call	addnum
			jmp		print_index

		jmp2:
			push	len2
			push	len1
			push	offset	s1
			call	add_zero
			jmp		jmp1

		jmp3:
			push	len1
			push	len2
			push	offset	s2
			call	add_zero
			jmp		jmp1
		
		print_index:
			push	offset s3
			call	reverse

			push	offset s3
			call	StdOut

			push	offset bspace
			call	StdOut
		
			mov		ecx, num_n
			dec		ecx
			cmp		ecx, 0
			jz		exit
			mov		num_n, ecx
			jmp		next

	exit:
		push	0
		call	ExitProcess

main ENDP

add_zero PROC
	push	ebp
	mov		ebp, esp
	push	eax
	mov		eax, [ebp + 08h]		;n1
	push	esi
	push	edi
	mov		esi, [ebp + 0Ch]		;short len	
	mov		edi, [ebp + 10h]		;long len

	pro:
		mov		byte ptr [eax + esi], '0'
		inc		esi
		cmp		esi, edi
		jz		break
		jmp		pro

	break:
		pop		edi	
		pop		esi
		pop		eax
		pop		ebp
		ret		12
add_zero ENDP

len PROC
	push	ebp
	mov		ebp, esp
	mov		eax, 0
	mov		esi, 0
	mov		ebx, [ebp + 08h]

	pro1:
		cmp		byte ptr[ebx + esi], 0
		jz		done
		jmp		pro2

	pro2:
		inc		esi
		jmp		pro1

	done:
		mov		eax, esi
		pop		ebp
		ret
len ENDP

copy PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	mov		eax, [ebp + 08h]		;chuoi duoc copy
	mov		ebx, [ebp + 0Ch]		;chuoi xuat gia tri
	xor		esi, esi

	pro:
		mov		dl, byte ptr[eax + esi]
		cmp		dl, 0
		jz		done
		mov		byte ptr[ebx + esi], dl
		inc		esi
		jmp		pro

	done:
		mov		byte ptr [ebx + esi], 0
		inc		esi
		pop		ebx
		pop		eax
		pop		ebp
		ret		8
copy ENDP

addnum PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	ecx
	mov		eax, [ebp + 10h]		
	mov		ebx, [ebp + 0Ch]		
	mov		ecx, [ebp + 08h]		
	mov		esi, 0
	mov		edi, 0

	pro1:
		mov		edx, 0
		mov		dl, byte ptr [eax + esi]
		mov		dh, byte ptr [ebx + esi]
		cmp		dl, 0
		jz		done
		sub		dl, 30h
		sub		dh, 30h
		add		dl, dh
		mov		dh, 0
		add		edx, mem
		mov		mem, 0
		cmp		dl,	10
		jnc		pro2

	pro3: 
		add		dl, 30h
		mov		byte ptr [ecx + esi], dl
		inc		esi
		jmp		pro1


	pro2:
		mov		mem, 1
		sub		dl, 10
		jmp		pro3

	done:
		mov		edx, 0
		mov		edx, mem
		cmp		dl, 0
		je		end_pro
		add		dl, 30h
		mov		byte ptr [ecx + esi], dl
		inc		esi

	end_pro:
		mov		byte ptr [ecx + esi], 0
		pop		ecx
		pop		ebx
		pop		eax
		pop		ebp
		ret		12
addnum ENDP

reverse PROC
	push 	ebp
	mov		ebp, esp			
	push	eax
	push	ebx
	mov		eax, [ebp+08h]		;eax = offset input
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
		xor		edx, edx
		pop		edx
		cmp		dl, 0h
		jz		break
		mov		byte ptr[eax + edi], dl
		inc		edi
		jmp		pop_string

	break:
		mov		byte ptr[eax + edi], 0
		pop		ebx
		pop		eax
		pop		ebp
		ret		8
reverse ENDP

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
END main