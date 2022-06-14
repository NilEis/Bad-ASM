bits 64
extern printf
default rel
global main
%macro mmov 2
	mov dx, word[mem+%2]
	mov word[mem+%1], dx
%endmacro
%macro mcmp 2
	mov dx, word[mem+%2]
	cmp word[mem+%1], dx
%endmacro
%macro madd 3
	mov dx, word[mem+%2]
	add dx, word[mem+%3]
	mov word[mem+%1], dx
%endmacro
%macro msub 3
	mov dx, word[mem+%2]
	sub dx, word[mem+%3]
	mov word[mem+%1], dx
%endmacro
%macro mmul 3
	mov dx, word[mem+%2]
	imul dx, word[mem+%3]
	mov word[mem+%1], dx
%endmacro
%macro mdiv 3
	mov dx, word[mem+%2]
	idiv dx, word[mem+%3]
	mov word[mem+%1], dx
%endmacro
%macro mand 3
	mov dx, word[mem+%2]
	and dx, word[mem+%3]
	mov word[mem+%1], dx
%endmacro
%macro mor 3
	mov dx, word[mem+%2]
	or dx, word[mem+%3]
	mov word[mem+%1], dx
%endmacro
%macro mxor 3
	mov dx, word[mem+%2]
	xor dx, word[mem+%3]
	mov word[mem+%1], dx
%endmacro
section .text
main:
	push rbp
	mov rbp, rsp
	mov word[mem+20], 10
	mov dx, word [mem+20]
	movzx edx, dx
	xor eax, eax
	lea rcx, _0
	call printf
	xor eax, eax
	lea rcx, _1
	call printf
	mov rsp, rbp
	pop rbp
	ret
section .data
mem: times 4096 db 0
_0: db 34, 90, 101, 108, 108, 101, 32, 49, 48, 32, 104, 97, 116, 32, 100, 101, 110, 32, 87, 101, 114, 116, 32, 37, 100, 92, 110, 34, 10, 0
_1: db 34, 70, 101, 114, 116, 105, 103, 92, 110, 34, 10, 0
