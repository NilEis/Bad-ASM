bits 64
extern printf
default rel
global main
%macro mmov 2
	lea rdx, [mem+%2]
	mov dx, word[rdx]
	lea rdx, [mem+%1]
	mov [rdx], word dx
%endmacro
%macro mcmp 2
	lea rdx, [mem+%2]
	mov dx, word[rdx]
	lea rdx, [mem+%1]
	cmp [rdx], word dx
%endmacro
%macro madd 3
	lea rdx, [mem+%2]
	mov dx, word[rdx]
	lea rdx, [mem+%3]
	add dx, word[rdx]
	lea rdx, [mem+%1]
	mov [rdx], word dx
%endmacro
%macro msub 3
	lea rdx, [mem+%2]
	mov dx, word[rdx]
	lea rdx, [mem+%3]
	sub dx, word[rdx]
	lea rdx, [mem+%1]
	mov [rdx], word dx
%endmacro
%macro mmul 3
	lea rdx, [mem+%2]
	mov dx, word[rdx]
	lea rdx, [mem+%3]
	imul dx, word[rdx]
	lea rdx, [mem+%1]
	mov [rdx], word dx
%endmacro
%macro mdiv 3
	lea rdx, [mem+%2]
	mov dx, word[rdx]
	lea rdx, [mem+%3]
	idiv dx, word[rdx]
	lea rdx, [mem+%1]
	mov [rdx], word dx
%endmacro
%macro mand 3
	lea rdx, [mem+%2]
	mov dx, word[rdx]
	lea rdx, [mem+%3]
	and dx, word[rdx]
	lea rdx, [mem+%1]
	mov [rdx], word dx
%endmacro
%macro mor 3
	lea rdx, [mem+%2]
	mov dx, word[rdx]
	lea rdx, [mem+%3]
	or dx, word[rdx]
	lea rdx, [mem+%1]
	mov [rdx], word dx
%endmacro
%macro mxor 3
	lea rdx, [mem+%2]
	mov dx, word[rdx]
	lea rdx, [mem+%3]
	xor dx, word[rdx]
	lea rdx, [mem+%1]
	mov [rdx], word dx
%endmacro
section .text
main:
	push rbp
	mov rbp, rsp
a:
	lea rdx, [mem+20]
	mov [rdx], word 10
b:
	mov dx, word [mem+20]
	movzx edx, dx
	xor eax, eax
	lea rcx, _0
	call printf
l:
	mov dx, word [mem+20]
	movzx edx, dx
	xor eax, eax
	lea rcx, _1
	call printf
c:
	mov r8, 20
	lea rdx, [mem+20]
	mov r8w, word[rdx]
	sub r8w, 1
	lea rdx, [mem+r8]
	mov [rdx], word r8w
d:
	lea rdx, [mem+20]
	cmp [rdx], word 0
e:
	jz l
f:
	xor eax, eax
	lea rcx, _2
	call printf
	mov rsp, rbp
	pop rbp
	ret
section .data
mem: times 4096 db 0
_0: db 34, 90, 101, 108, 108, 101, 32, 49, 48, 32, 104, 97, 116, 32, 100, 101, 110, 32, 87, 101, 114, 116, 32, 37, 100, 92, 110, 34, 10, 0
_1: db 34, 90, 101, 108, 108, 101, 32, 49, 48, 32, 104, 97, 116, 32, 100, 101, 110, 32, 87, 101, 114, 116, 32, 37, 100, 92, 110, 34, 10, 0
_2: db 34, 70, 101, 114, 116, 105, 103, 92, 110, 34, 10, 0
