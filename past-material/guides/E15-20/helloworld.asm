; Assemble and link like this:
;     nasm -f elf -gstabs helloworld.asm
;     ld -o helloworld -m elf_i386 helloworld.o
; Run like this:
;     ./helloworld

; The data section is for initialized data
section .data

; hello_text is the address of the beginning of the string.
; The string is simply a byte array, created with db.
; Note that the string includes a newline character (10).

hello_text: db "Hello, world", 10
hello_text_end:

; hello_text_len is the difference between the address of the
; byte after the string and the address of the first byte
; of the string, in other words the length of the string (in bytes).
; The EQU syntax declares a new compile-time symbol,
; similar to a label, but in this case hello_text_len
; designates a difference between addresses, not an address.

hello_text_len equ hello_text_end-hello_text

; The text section is for code
section .text
global _start

; Special symbol _start identifies entry point
_start:

; Print the given string
    mov eax, 4                ; select write syscall
    mov ebx, 1                ; file descriptor: stdout
    mov ecx, hello_text       ; address of string
    mov edx, hello_text_len   ; length of string
    int 80h                   ; do it

; We're done, tell the OS to kill us
    mov eax, 1                ; select exit syscall
    mov ebx, 0                ; exit status
    int 80h                   ; do it

; We never get here
