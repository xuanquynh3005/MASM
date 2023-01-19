.386
.model flat, stdcall
option casemap:none

include D:\masm32\include\kernel32.inc 
include D:\masm32\include\masm32.inc 
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\masm32.lib

.data
	mess1	db	"Number 1: ", 0h
	mess2	db	"Number 2: ", 0h
	num_1	db	100 dup(?)
	num_2	db	100 dup(?)
	num1	db	100 dup(?)
	num2	db	100 dup(?)
	sum		db	100 dup(?)
	len1	dd	0
	len2	dd	0
	lensum	dd	0
	mem		dd	0

.code
main PROC
	input_num1:
		push	100
		push	offset	mess1
		call	StdOut

		push	100
		push	offset	num_1
		call	StdIn
		mov		al, byte ptr [num_1]
		cmp		al, '-'								;if negative number -> retype
		jz		input_num1
	
	input_num2:
		push	100
		push	offset mess2
		call	StdOut

		push	100
		push	offset	num_2
		call	StdIn
		mov		al, byte ptr [num_2]
		cmp		al, '-'							
		jz		input_num2
	
	push	offset num_1
	push	offset num1
	call	check_num							;check if the input string is not all number -> return a number

	push	offset num_2
	push	offset num2
	call	check_num
			
	push	offset	num1
	call	reverse								;reverse string

	push	offset	num2
	call	reverse

	push	offset	num1
	call	strlen
	mov		len1, eax						;num1.length

	push	offset	num2
	call	strlen
	mov		len2, eax						;num2.length

	mov		eax, len1
	mov		ebx, len2
	cmp		eax, ebx						;num1.length = num2.length
	jz		equal_strlen
	cmp		eax, ebx						;num1.length < num2.length
	jl		different_strlen1
	cmp		eax, ebx						;num1.length > num2.length
	jg		different_strlen2
	
	equal_strlen:
		push	offset	num1
		push	offset	num2
		push	offset	sum					;sum = num1 + num2
		call	add_num
		jmp		end_pro

	different_strlen1:
		push	len2						;num1.length < num2.length
		push	len1
		push	offset	num1				;add zero to num1
		call	add_zero
		jmp		equal_strlen

	different_strlen2:
		push	len1						;num1.length > num2.length
		push	len2
		push	offset	num2				;add zero to num2
		call	insert_zero
		jmp		equal_strlen

	end_pro:
		push	offset	sum
		call	reverse
		
		push	offset sum
		call	strlen
		mov		lensum, eax

		mov		ecx, lensum

		cmp		ecx, 0h						;if lensum = Null -> print 0
		jz		print_zero

		print_result:
			push	offset	sum
			call	StdOut
			jmp		exit

		print_zero:
			mov		edx, offset sum
			mov		byte ptr[edx], '0'
			jmp		print_result
	exit:		
		push	0
		call	ExitProcess
main ENDP

check_num PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	mov		eax, [ebp + 0Ch]
	mov		ebx, [ebp + 08h]
	xor		esi, esi
	xor		edx, edx
	xor		edi, edi

	check: 
		mov		dl, byte ptr[eax + esi]
		cmp		dl, 0h
		je		end_check
		cmp		dl, 30h									;if dl != number -> continue
		jl		continue
		cmp		dl, 39h
		jg		continue
		inc		esi
		mov		byte ptr[ebx + edi], dl					;if dl == number -> num[edi] = dl
		inc		edi
		jmp		check

	continue:
		inc		esi
		jmp		check

	end_check:
		mov		byte ptr[ebx + edi], 0h
		pop		ebx
		pop		eax
		pop		ebp
		ret
check_num ENDP

insert_zero PROC
	push	ebp
	mov		ebp, esp
	push	eax
	mov		eax, [ebp + 08h]		;smaller number
	push	esi
	push	edi
	mov		edi, [ebp + 10h]		;long len
	mov		esi, [ebp + 0Ch]		;short len	
	
	add_zer0:
		mov		byte ptr [eax + esi], '0'			;add zero to number until short len = long len (esi = edi)
		inc		esi
		cmp		esi, edi
		jz		break
		jmp		add_zer0

	break:
		pop		edi	
		pop		esi
		pop		eax
		pop		ebp
		ret		12
insert_zero ENDP
	
strlen PROC
	push	ebp
	mov		ebp, esp
	mov		eax, 0
	mov		esi, 0
	mov		ebx, [ebp + 08h]			;string

	count:
		cmp		byte ptr[ebx + esi], 0
		jz		done
		jmp		increase

	increase:
		inc		esi						;increase esi until str[esi] = Null -> strlen = esi
		jmp		count

	done:
		mov		eax, esi
		pop		ebp
		ret
strlen ENDP

add_num PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	ecx	
	mov		eax, [ebp + 10h]				;num1
	mov		ebx, [ebp + 0Ch]				;num2
	mov		ecx, [ebp + 08h]				;sum		
	mov		esi, 0
	mov		edi, 0

	add_str:
		mov		edx, 0
		mov		dl, byte ptr [eax + esi]		
		mov		dh, byte ptr [ebx + esi]
		cmp		dl, 0
		jz		done
		sub		dl, 30h
		sub		dh, 30h
		add		dl, dh						;dl = dl + dh
		mov		dh, 0
		add		edx, mem
		mov		mem, 0
		cmp		dl,	10						;if dl >= 10, carry flag (CF) = 0
		jnc		calc_mem					;jump if CF = 0

	to_strg: 
		add		dl, 30h						;convert number to string
		mov		byte ptr [ecx + esi], dl
		inc		esi
		jmp		add_str						;return to add_str to add the next character


	calc_mem:
		mov		mem, 1						
		sub		dl, 10
		jmp		to_strg

	done:
		mov		edx, 0
		mov		edx, mem
		cmp		dl, 0
		je		end_pro
		add		dl, 30h
		mov		byte ptr [ecx + esi], dl				;if dl != 0 -> mem != 0 -> add mem to the end of the string
		inc		esi

	end_pro:
		mov		byte ptr [ecx + esi], 0
		pop		ecx
		pop		ebx
		pop		eax
		pop		ebp
		ret		12
add_num ENDP

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