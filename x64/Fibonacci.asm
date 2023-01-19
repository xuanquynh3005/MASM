extrn GetStdHandle	:PROC
extrn WriteFile		:PROC
extrn ReadFile		:PROC
extrn ExitProcess	:PROC

.data
	n		db	100 dup(?)
	num_n	dq	0
	print0	db	'0', 20h, 20h, 0
	print1	db	'1', 20h, 20h, 0
	bspace	db	20h, 20h, 0
	s1		db	99 dup(0), 0
	s2		db	99 dup(0), 0
	s3		db	100 dup(0)
	len1	dq	0
	len2	dq	0
	mem		dq	0
	nByte	dd	?

.code
main PROC
	mov		rbp, rsp
	sub		rsp, 38h
	
	mov		rcx, -10
	call	GetStdHandle
	mov		[rbp - 08h], rax
	mov		rcx, -11
	call	GetStdHandle
	mov		[rbp - 10h], rax

	xor		rbx, rbx
	mov		rcx, [rbp - 08h]
	mov		rdx, offset n
	mov		r8, 100
	mov		r9, offset nByte
	mov		[rbp + 20h], rbx
	call	ReadFile

	mov		rbx, offset n
	call	atoi
	mov		num_n, rax

	cmp		num_n, 0		;if num_n = 0 -> print 0
	jz		print00
	cmp		num_n, 1		;if num_n = 1 -> print 1
	jz		print01
	jmp		print_fibo		;if num_n != 0 && num_n != 1 -> print fibonacci

	print00:
		xor		rbx, rbx
		mov		rcx, [rbp - 10h]
		mov		rdx, offset print0
		mov		r8, sizeof print0
		mov		r9, offset nByte
		mov		[rbp + 20h], rbx
		call	WriteFile

		jmp		exit
		
	print01:
		xor		rbx, rbx
		mov		rcx, [rbp - 10h]
		mov		rdx, offset print1
		mov		r8, sizeof print1
		mov		r9, offset nByte
		mov		[rbp + 20h], rbx
		call	WriteFile

		jmp		exit

	print_fibo:
		xor		rbx, rbx
		mov		rcx, [rbp - 10h]
		mov		rdx, offset print0
		mov		r8, sizeof print0
		mov		r9, offset nByte
		mov		[rbp + 20h], rbx
		call	WriteFile

		xor		rbx, rbx
		mov		rcx, [rbp - 10h]
		mov		rdx, offset print1
		mov		r8, sizeof print1
		mov		r9, offset nByte
		mov		[rbp + 20h], rbx
		call	WriteFile

		mov		r15, 2
		mov		rax, num_n
		sub		rax, r15
		mov		num_n, rax
		mov		rax, 0

		push	rcx
		mov		rcx, offset s1
		mov		byte ptr[rcx], '0'
		mov		rcx, offset s2
		mov		byte ptr[rcx], '1'
		pop		rcx
		jmp		find_fibo

	find_fibo:
		mov		r11, num_n
		cmp		r11, 0
		jz		exit

		mov		r13, offset s1
		push	r13
		call	reverse

		mov		r13, offset s2
		push	r13
		call	reverse
		
		add_fibo:
			mov		rsi, offset s1
			call	strlen
			mov		len1, rax

			mov		rsi, offset s2
			call	strlen
			mov		len2, rax

			mov		rax, len1
			mov		rbx, len2
			cmp		rax, rbx						;num1.length = num2.length
			jz		equal_strlen
			cmp		rax, rbx						;num1.length < num2.length
			jl		different_strlen1
			cmp		rax, rbx						;num1.length > num2.length
			jg		different_strlen2

		copy_str:
			mov		rsi, offset s2
			mov		rdi, offset s1
			call	copy

			mov		rsi, offset s3
			mov		rdi, offset s2
			call	copy

			jmp		find_fibo

		equal_strlen:
			mov		rsi, offset	s1
			mov		rdi, offset	s2
			mov		rax, offset	s3				;sum = num1 + num2
			call	add_num
			jmp		print_index

		different_strlen1:
			mov		rsi, len2						;num2.length > num1.length
			mov		rdi, len1
			mov		r12, offset s1				;insert zero to num1
			call	insert_zero
			jmp		equal_strlen

		different_strlen2:
			mov		rsi, len1						;num1.length > num2.length
			mov		rdi, len2
			mov		r12, offset s2				;insert zero to num2
			call	insert_zero
			jmp		equal_strlen
		
		print_index: 
			mov		r13, offset s3
			push	r13
			call	reverse

			xor		rbx, rbx
			mov		rcx, [rbp - 10h]
			mov		rdx, offset s3
			mov		r8, sizeof s3
			mov		r9, offset nByte
			mov		[rbp + 20h], rbx
			call	WriteFile

			xor		rbx, rbx
			mov		rcx, [rbp - 10h]
			mov		rdx, offset bspace
			mov		r8, sizeof bspace
			mov		r9, offset nByte
			mov		[rbp + 20h], rbx
			call	WriteFile

			mov		r14, num_n
			dec		r14
			cmp		r14, 0
			jz		exit
			mov		num_n, r14
			jmp		copy_str

		exit:
			mov		ecx, 0
			call	ExitProcess
main ENDP

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
		cmp		byte ptr[rsi], 0
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
		cmp		dl, 0
		jz		done
		cmp		dh, 0
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
		mov		byte ptr [rax + rcx], 0
		inc		rcx
		mov		rsp, rbp
		pop		rbp
		ret		
add_num ENDP

copy PROC				;rsi = &input (string), rdi = &output (copied string)
	push	rbp
	mov		rbp, rsp

	cop:
		mov		dl, byte ptr[rsi]
		cmp		dl, 0
		jz		done
		mov		byte ptr[rdi], dl
		inc		rsi
		inc		rdi
		jmp		cop

	done:
		mov		byte ptr[rdi], 0
		inc		rdi
		mov		rbp, rsp
		pop		rbp
		ret
copy ENDP

reverse PROC
	push	rbp
	mov		rbp, rsp
	mov		rsi, [rbp + 10h]
	mov		rdi, [rbp + 10h]
	mov		rcx, 0

	pushString:
		mov		rax, 0
		mov		al, byte ptr[rsi]
		cmp		al, 0
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
		ret		8
reverse endp

atoi PROC								;rbx = &string
	push	rbp
	mov		rbp, rsp
	push	rbx
	xor		rsi, rsi
	xor		rax, rax
	xor		rdx, rdx
	mov		rdi, 10

	atoi_str:
		mov		dl, byte ptr [rbx + rsi]
		sub		dl, 30h
		add		al, dl
		inc		rsi
		cmp		byte ptr [rbx + rsi], 0Dh
		jz		pop_str
		mul		rdi
		xor		edx, edx
		jmp		atoi_str

	pop_str:
		pop		rbx
		mov		rbp, rsp
		pop		rbp
		ret
atoi ENDP
END