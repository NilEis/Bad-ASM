format PE
use32
macro mmov dest,src
{
    mov dx, word[mem+src]
    mov word[mem+dest], dx
}

macro mcmp dest,src
{
    mov dx, word[mem+src]
    cmp word[mem+dest], dx
}

entry main
section '.text' code readable executable
main:
mov word[1+1], 13
mmov 12, 13
cmp word[12], 12
mcmp 12, 16
add bx, word[mem+15]
mov eax, 13
mov word [mem+eax], 13
section '.data' data readable writeable
mem: dw 4096 dup 0