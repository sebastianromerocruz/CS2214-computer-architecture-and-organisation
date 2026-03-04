; Assemble and link like this:
;     nasm -f elf -gstabs uppercase.asm
;     ld -o uppercase -m elf_i386 uppercase.o
; Run like this:
;     ./uppercase

; The data section is for uninitialized data
section .bss

; We reserve 32 bytes to store our string
buffer: 
    resb 32

section .text

global _start
_start:

    ; Read in a string (max size 32) into the buffer
    ; We're using syscall 3, sys_read
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 32
    int 80h
    ; After this syscall, the length is returned in eax

    ; Initialize our counter to zero
    mov ecx, 0

    ;for (ecx=0; ecx<eax; ecx++)
    ;    mychar = buffer[ecx];
loop:
    ; Have we reached end of string?

    cmp ecx, eax
    jae done

    ; Read the next char
    mov bh, [buffer+ecx]

    ; Skip if not lower-case
    cmp bh, 97    ; 'a'
    jb skip
    cmp bh, 122   ; 'z'
    ja skip

    ; convert to upper case
    sub bh, 32    

    ; Store the new letter back to buffer
    mov [buffer+ecx], bh

skip:
    ; Go to next char
    inc ecx
    jmp loop

done:

    ; Print out the new string
    mov edx, eax
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    int 80h

    ; end the program
    mov eax, 1
    mov ebx, 0
    int 80h