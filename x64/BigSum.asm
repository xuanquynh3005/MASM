section .data
    
section .bss
    num1    resb 100
    num2    resb 100
    result  resb 101
    len1    resd 1
    len2    resd 1
    mem     resd 1

section .text
global _starts

_start:
    push    100
    push    num1
    call    read
    push    num1
    call    strlen
    mov     [len1], eax             ;len1

    push    100
    push    num2
    call    read
    push    num2    
    call    strlen
    mov     [len2], eax             ;len2   

    push    num1
    call    reverse
    push    num2
    call    reverse

    mov     eax, [len1]
    mov     ebx, [len2]
    cmp     eax, ebx
    jl      diff_str2            ;len1 < len2
    cmp     eax, ebx
    jg      diff_str1            ;len1 > len2

    add_str:                    ;len1 = len2
        push    num1
        push    num2
        push    result
        call    big_sum
        jmp     index

    diff_str2:
        mov     eax, [len2]         ;long_length
        mov     ebx, [len1]         ;short_length
        push    eax
        push    ebx
        push    num1
        call    insert_zero
        jmp     add_str

    diff_str1:
        mov     eax, [len1]         ;long_length
        mov     ebx, [len2]         ;short_length
        push    eax
        push    ebx
        push    num2
        call    insert_zero
        jmp     add_str

    index:
        push    result              
        call    reverse
        push    101
        push    result
        call    write

    mov     ebx, 0
    mov     eax, 1
    int     80h

big_sum:
    push    ebp
    mov     ebp, esp
    push    eax
    push    ebx
    push    ecx
    mov     eax, [ebp+10h]          ;num1
    mov     ebx, [ebp+0Ch]          ;num2
    mov     ecx, [ebp+08h]          ;result
    xor     esi, esi
    xor     edi, edi

    add_num:
        xor     edx, edx
        mov     dl, byte [eax+esi]
        mov     dh, byte [ebx+esi]
        cmp     dl, 0Ah
        jz      add_mem
        cmp     dh, 0Ah
        jz      add_mem
        sub     dl, 30h
        sub     dh, 30h
        add     dl, dh
        xor     dh, dh
        add     edx, [mem]
        mov     edi, 0
        mov     [mem], edi
        cmp     dl, 10
        jnc     high

    next:                          
        add     dl, 30h
        mov     byte [ecx+esi], dl
        inc     esi
        jmp     add_num

    high:                          ;sum>=10
        mov     edi, 1
        mov     [mem], edi
        sub     dl, 10
        jmp     next

    add_mem:                        
        xor     edx, edx
        mov     edx, [mem]
        cmp     dl, 0
        je      break
        add     dl, 30h
        mov     byte [ecx+esi], dl
        inc     esi

    break:
        mov     byte [ecx+esi], 0Ah
        inc     esi
        mov     byte [ecx+esi], 0h
        pop     ecx
        pop     ebx
        pop     eax
        mov     esp, ebp
        pop     ebp
        ret     12

insert_zero:
    push    ebp
    mov     ebp, esp
    push    eax
    push    ebx
    push    ecx
    mov     eax, [ebp+10h]          ;lendai
    mov     ebx, [ebp+0Ch]          ;lenngan
    mov     ecx, [ebp+08h]          ;strngan

    insert:
        cmp     eax, ebx
        jz      .break
        mov     byte [ecx+ebx], 30h
        inc     ebx
        jmp     .insert

    break:
        mov     byte [ecx+ebx], 0h
        pop     ecx
        pop     ebx
        pop     eax
        mov     esp, ebp
        pop     ebp
        ret     12

reverse: 
    push    ebp
    mov     ebp, esp
    push    ebx
    mov     ebx, [ebp+08h]          ;str
    xor     esi, esi

    re:
        xor     edx, edx
        mov     dl, [ebx+esi]
        cmp     dl, 0Ah 
        jz      popstr
        push    edx
        inc     esi
        jmp     re

    popstr:
        xor     edx, edx
        pop     edx
        mov     [ebx], dl
        inc     ebx
        dec     esi
        cmp     esi, 0h
        jz      break
        jmp     popstr

    break:
        pop     ebx
        pop     ebp
        ret     4
        
read:
    push    ebp
    mov     ebp, esp
    push    edx
    push    ecx
    push    ebx

    mov     edx, [ebp+0Ch]          ;num
    mov     ecx, [ebp+08h]          ;str
    mov     ebx, 0
    mov     eax, 3
    int     80h

    pop     ebx
    pop     ecx
    pop     edx
    mov     esp, ebp
    pop     ebp
    ret     8

write:
    push    ebp
    mov     ebp, esp
    push    edx
    push    ecx
    push    ebx
    push    eax

    mov     edx, [ebp+0Ch]          ;num
    mov     ecx, [ebp+08h]          ;str
    mov     ebx, 1
    mov     eax, 4
    int     80h

    pop     eax
    pop     ebx
    pop     ecx
    pop     edx
    mov     esp, ebp
    pop     ebp
    ret     8
