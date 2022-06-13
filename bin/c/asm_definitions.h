#ifndef ASM_DEFINITIONS_H
#define ASM_DEFINITIONS_H

char *asm_definitions[] = {
    "\
bits 64\n\
extern printf\n\
default rel\n\
global main\n\
%macro mmov 2\n\
\tmov dx, word[mem+%2]\n\
\tmov word[mem+%1], dx\n\
%endmacro\n\
%macro mcmp 2\n\
\tmov dx, word[mem+%2]\n\
\tcmp word[mem+%1], dx\n\
%endmacro\n\
%macro madd 3\n\
\tmov dx, word[mem+%2]\n\
\tadd dx, word[mem+%3]\n\
\tmov word[mem+%1], dx\n\
%endmacro\n\
%macro msub 3\n\
\tmov dx, word[mem+%2]\n\
\tsub dx, word[mem+%3]\n\
\tmov word[mem+%1], dx\n\
%endmacro\n\
%macro mmul 3\n\
\tmov dx, word[mem+%2]\n\
\timul dx, word[mem+%3]\n\
\tmov word[mem+%1], dx\n\
%endmacro\n\
%macro mdiv 3\n\
\tmov dx, word[mem+%2]\n\
\tidiv dx, word[mem+%3]\n\
\tmov word[mem+%1], dx\n\
%endmacro\n\
%macro mand 3\n\
\tmov dx, word[mem+%2]\n\
\tand dx, word[mem+%3]\n\
\tmov word[mem+%1], dx\n\
%endmacro\n\
%macro mor 3\n\
\tmov dx, word[mem+%2]\n\
\tor dx, word[mem+%3]\n\
\tmov word[mem+%1], dx\n\
%endmacro\n\
%macro mxor 3\n\
\tmov dx, word[mem+%2]\n\
\txor dx, word[mem+%3]\n\
\tmov word[mem+%1], dx\n\
%endmacro\n\
section .text\n\
main:\n\
",
    "\tmov word[mem+%d], %d\n",
    "\tmmov %d, %d\n",
    "\tcmp %d, %d\n",
    "\tcmp %d, word [mem+%d]\n",
    "\tcmp word [mem+%d], %d\n",
    "\tmcmp word %d, %d\n",
    "\tjmp %s\n",
    "\tjnz %s\n",
    "\tjz %s\n",
    "\tjg %s\n",
    "\tjl %s\n",
    "\tmov word[mem+%d], %d\n",
    "\tmov eax, %d\n\tmov bx, %d\n\tadd bx, word[mem+%d]\n\tmov word [mem+eax], bx\n",
    "\tmov eax, %d\n\tmov bx, word[mem+%d]\n\tadd bx, %d\n\tmov word [mem+eax], bx\n",
    "\tmadd %d, %d, %d\n",
    "\tmov word[mem+%d], %d\n",
    "\tmov eax, %d\n\tmov bx, %d\n\tsub bx, word[mem+%d]\n\tmov word [mem+eax], bx\n",
    "\tmov eax, %d\n\tmov bx, word[mem+%d]\n\tsub bx, %d\n\tmov word [mem+eax], bx\n",
    "\tmsub %d, %d, %d\n",
    "\tmov word[mem+%d], %d\n",
    "\tmov eax, %d\n\tmov bx, %d\n\timul bx, word[mem+%d]\n\tmov word [mem+eax], bx\n",
    "\tmov eax, %d\n\tmov bx, word[mem+%d]\n\timul bx, %d\n\tmov word [mem+eax], bx\n",
    "\tmmul %d, %d, %d\n",
    "\tmov word[mem+%d], %d\n",
    "\tmov eax, %d\n\tmov bx, %d\n\tidiv bx, word[mem+%d]\n\tmov word [mem+eax], bx\n",
    "\tmov eax, %d\n\tmov bx, word[mem+%d]\n\tidiv bx, %d\n\tmov word [mem+eax], bx\n",
    "\tmdiv %d, %d, %d\n",
    "\tmov word[mem+%d], %d\n",
    "\tmov eax, %d\n\tmov bx, %d\n\tand bx, word[mem+%d]\n\tmov word [mem+eax], bx\n",
    "\tmov eax, %d\n\tmov bx, word[mem+%d]\n\tand bx, %d\n\tmov word [mem+eax], bx\n",
    "\tmand %d, %d, %d\n",
    "\tmov word[mem+%d], %d\n",
    "\tmov eax, %d\n\tmov bx, %d\n\tor bx, word[mem+%d]\n\tmov word [mem+eax], bx\n",
    "\tmov eax, %d\n\tmov bx, word[mem+%d]\n\tor bx, %d\n\tmov word [mem+eax], bx\n",
    "\tor %d, %d, %d\n",
    "\tmov word[mem+%d], %d\n",
    "\tmov eax, %d\n\tmov bx, %d\n\txor bx, word[mem+%d]\n\tmov word [mem+eax], bx\n",
    "\tmov eax, %d\n\tmov bx, word[mem+%d]\n\txor bx, %d\n\tmov word [mem+eax], bx\n",
    "\txor %d, %d, %d\n",
    "",
    "",
    "",/*NOT IMPLEMENTED*/
    "",/*NOT IMPLEMENTED*/
    "",/*NOT IMPLEMENTED*/
    "",/*NOT IMPLEMENTED*/
    "",/*NOT IMPLEMENTED*/
    "%s\n",
    "\tret\n",/*NOT IMPLEMENTED*/
    "\tret\nsection .data\nmem: times 4096 db 0\n"};

#endif // ASM_DEFINITIONS_H
