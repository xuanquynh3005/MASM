extrn GetStdHandle	:PROC
extrn WriteFile		:PROC
extrn ReadFile		:PROC
extrn ExitProcess	:PROC

.data
	mess1	db	"Number 1: ", 0h
	mess2	db	"Number 2: ", 0h
	num_1	db	100 dup(?), 0Ah
	num_2	db	100 dup(?), 0Ah
	num1	db	100 dup(?)
	num2	db	100 dup(?)
	sum		db	100 dup(?)
	len1	dq	0
	len2	dq	0
	lensum	dq	0
	mem		dq	0
	nByte	dd	?

.code
main PROC
	input_num1:
		mov		rbp, rsp
		sub		rsp, 28h
		
		xor		rbx, rbx
		mov		rcx, -11		;STD_OUTPUT_HANDLE
		call	GetStdHandle
		mov		rcx, rax
		mov		rdx, offset mess1
		mov		r8, 10
		mov		r9, offset nByte
		mov		[rsp + 20h], rbx
		call	WriteFile

		xor		rbx, rbx
		mov		rcx, -10		;STD_INPUT_HANDLE
		call	GetStdHandle
		mov		rcx, rax
		mov		rdx, offset num_1
		mov		r8, 100
		mov		r9, offset nByte
		mov		[rsp + 20h], rbx
		call	ReadFile

		mov		al, byte ptr [num_1]
		cmp		al, '-'								;if negative number -> retype
		jz		input_num1
	
	input_num2:
		xor		rbx, rbx
		mov		rcx, -11		;STD_OUTPUT_HANDLE
		call	GetStdHandle
		mov		rcx, rax
		mov		rdx, offset mess2
		mov		r8, 10
		mov		r9, offset nByte
		mov		[rsp + 20h], rbx
		call	WriteFile

		xor		rbx, rbx
		mov		rcx, -10		;STD_INPUT_HANDLE
		call	GetStdHandle
		mov		rcx, rax
		mov		rdx, offset num_2
		mov		r8, 100
		mov		r9, offset nByte
		mov		[rsp + 20h], rbx
		call	ReadFile

		mov		al, byte ptr [num_2]
		cmp		al, '-'							
		jz		input_num2
	
	mov		rsi, offset num_1
	mov		rdi, offset num1
	call	check_num							;check if the input string is not all number -> return a full number

	mov		rsi, offset num_2
	mov		rdi, offset num2
	call	check_num
			
	mov		r13, offset	num1
	push	r13
	call	reverse								;reverse string

	mov		r13, offset	num2
	push	r13
	call	reverse

	mov		rsi, offset	num1
	call	strlen
	mov		len1, rax						;num1.length

	mov		rsi, offset	num2
	call	strlen
	mov		len2, rax						;num2.length

	mov		rax, len1
	mov		rbx, len2
	cmp		rax, rbx						;num1.length = num2.length
	jz		equal_strlen
	cmp		rax, rbx						;num1.length < num2.length
	jl		different_strlen1
	cmp		rax, rbx						;num1.length > num2.length
	jg		different_strlen2
	
	equal_strlen:
		mov		rsi, offset	num1
		mov		rdi, offset	num2
		mov		rax, offset	sum					;sum = num1 + num2
		call	add_num
		jmp		end_pro

	different_strlen1:
		mov		rsi, len2						;num2.length > num1.length
		mov		rdi, len1
		mov		r12, offset num1				;insert zero to num1
		call	insert_zero
		jmp		equal_strlen

	different_strlen2:
		mov		rsi, len1						;num1.length > num2.length
		mov		rdi, len2
		mov		r12, offset num2				;insert zero to num2
		call	insert_zero
		jmp		equal_strlen

	end_pro:
		mov		r13, offset	sum
		push	r13
		call	reverse
		
		mov		rsi, offset sum
		call	strlen
		mov		lensum, rax

		mov		rcx, lensum

		cmp		rcx, 0h						;if lensum = Null -> print 0
		jz		print_zero

		print_result:
			xor		rbx, rbx
			mov		rcx, -11		;STD_OUTPUT_HANDLE
			call	GetStdHandle
			mov		rcx, rax
			mov		rdx, offset sum
			mov		r8, 100
			mov		r9, offset nByte
			mov		[rsp + 20h], rbx
			call	WriteFile
			jmp		exit

		print_zero:
			mov		rdx, offset sum
			mov		byte ptr[rdx], '0'
			jmp		print_result

	exit:		
		mov		rcx, 0
		call	ExitProcess
main ENDP

check_num PROC						;rsi = &num_1, rdi = &num1 
	push	rbp
	mov		rbp, rsp
	push	rdx

	check: 
		mov		dl, byte ptr[rsi]
		cmp		dl, 0Dh
		je		end_check
		cmp		dl, 30h								;if dl != number -> continue
		jl		continue
		cmp		dl, 39h
		jg		continue
		inc		rsi
		mov		byte ptr[rdi], dl					;if dl == number -> num[edi] = dl
		inc		rdi
		jmp		check

	continue:
		inc		rsi
		jmp		check

	end_check:
		mov		word ptr[rdi], 0A0Dh				;add \r\n to the string
		pop		rbx
		pop		rax
		mov		rsp, rbp
		pop		rbp
		ret
check_num ENDP

insert_zero PROC				;rsi = long_length, rdi = short_length -> return r12 = small_num is added zero
	push	rbp
	mov		rbp, rsp
	
	add_zer0:
		mov		byte ptr [r12 + rdi], '0'			;add zero to number until short_length = long_length (edi = esi)
		inc		rdi
		cmp		rdi, rsi
		jz		break
		jmp		add_zer0

	break:
		pop		rdi	
		pop		rsi
		pop		rax
		mov		rsp, rbp
		pop		rbp
		ret		
insert_zero ENDP
	
strlen PROC								;rsi = &num -> rax = num.length
	push	rbp
	mov		rbp, rsp
	mov		rax, 0

	count:
		cmp		byte ptr[rsi], 0Dh
		jz		done
		inc		rsi						;increase rsi and rax until str[rsi] = \r -> strlen = rax
		inc		rax
		jmp		count

	done:
		mov		rsp, rbp
		pop		rbp
		ret
strlen ENDP

add_num PROC							;rsi = &num1, rdi = &num2, r12 = &sum
	push	rbp
	mov		rbp, rsp
	xor		rbx, rbx
	xor		rcx, rcx

	add_str:
		mov		rdx, 0
		mov		dl, byte ptr [rsi + rbx]		
		mov		dh, byte ptr [rdi + rbx]
		cmp		dl, 0Dh
		jz		done
		cmp		dh, 0Dh
		jz		done
		sub		dl, 30h
		sub		dh, 30h
		add		dl, dh						;dl = dl + dh
		mov		dh, 0
		add		rdx, mem
		mov		mem, 0
		cmp		dl,	10						;if dl >= 10, carry flag (CF) = 0
		jnc		calc_mem					;jump if CF = 0

	to_strg: 
		add		dl, 30h						;convert number to string
		mov		byte ptr [rax + rcx], dl	;sum = dl
		inc		rcx
		inc		rbx
		jmp		add_str						;return to add_str to add the next character


	calc_mem:
		mov		mem, 1						;if dl >= 10 -> mem = 1 -> return (dl - 10)
		sub		dl, 10
		jmp		to_strg

	done:
		mov		rdx, 0
		mov		rdx, mem
		cmp		dl, 0h
		je		end_pro
		add		dl, 30h
		mov		byte ptr [rax + rcx], dl				;if dl != 0 -> mem != 0 -> add mem to the end of the string
		inc		rcx
		inc		rbx

	end_pro:
		mov		word ptr [rax + rcx], 0A0Dh
		mov		rsp, rbp
		pop		rbp
		ret		
add_num ENDP

reverse proc
	push	rbp
	mov		rbp, rsp
	mov		rsi, [rbp + 10h]
	mov		rdi, [rbp + 10h]
	mov		rcx, 0

	pushString:
		mov		rax, 0
		mov		al, byte ptr[rsi]
		cmp		al, 0Dh
		jz		popString
		push	rax
		inc		rsi
		inc		rcx
		jmp		pushString

	popString:
		test	rcx, rcx
		jz		exit
		mov		rax, 0
		pop		rax
		mov		byte ptr[rdi], al
		inc		rdi
		dec		rcx
		jmp		popString
	exit: 
		pop		rbp
		ret		
reverse endp
END