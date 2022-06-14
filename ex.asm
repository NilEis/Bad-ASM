bits 64
default rel
global main
section .text
extern printf
main:
	push rbp
    mov rbp, rsp
	lea rcx, [rel _0]
	mov rdx, 12
	xor eax, eax
	call printf
	mov rsp, rbp
	pop rbp
	ret
section .data
mem: times 4096 db 0
_0: db "TEST %d", 10 , 0