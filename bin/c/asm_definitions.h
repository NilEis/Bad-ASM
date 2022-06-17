#ifndef ASM_DEFINITIONS_H
#define ASM_DEFINITIONS_H

char *asm_definitions[] = {
    "\
bits 64\n\
extern printf\n\
default rel\n\
global main\n\
%macro mmov 2\n\
\tlea rdx, mem+%2\n\tmov dx, word[rdx]\n\
\tlea rdx, mem+%1\n\tmov [rdx], word dx\n\
%endmacro\n\
%macro mcmp 2\n\
\tlea rdx, mem+%2\n\tmov dx, word[rdx]\n\
\tlea rdx, mem+%1\n\tcmp [rdx], word dx\n\
%endmacro\n\
%macro madd 3\n\
\tlea rdx, mem+%2\n\tmov dx, word[rdx]\n\
\tlea rdx, mem+%3\n\tadd dx, word[rdx]\n\
\tlea rdx, mem+%1\n\tmov [rdx], word dx\n\
%endmacro\n\
%macro msub 3\n\
\tlea rdx, mem+%2\n\tmov dx, word[rdx]\n\
\tlea rdx, mem+%3\n\tsub dx, word[rdx]\n\
\tlea rdx, mem+%1\n\tmov [rdx], word dx\n\
%endmacro\n\
%macro mmul 3\n\
\tlea rdx, mem+%2\n\tmov dx, word[rdx]\n\
\tlea rdx, mem+%3\n\timul dx, word[rdx]\n\
\tlea rdx, mem+%1\n\tmov [rdx], word dx\n\
%endmacro\n\
%macro mdiv 3\n\
\tlea rdx, mem+%2\n\tmov dx, word[rdx]\n\
\tlea rdx, mem+%3\n\tidiv dx, word[rdx]\n\
\tlea rdx, mem+%1\n\tmov [rdx], word dx\n\
%endmacro\n\
%macro mand 3\n\
\tlea rdx, mem+%2\n\tmov dx, word[rdx]\n\
\tlea rdx, mem+%3\n\tand dx, word[rdx]\n\
\tlea rdx, mem+%1\n\tmov [rdx], word dx\n\
%endmacro\n\
%macro mor 3\n\
\tlea rdx, mem+%2\n\tmov dx, word[rdx]\n\
\tlea rdx, mem+%3\n\tor dx, word[rdx]\n\
\tlea rdx, mem+%1\n\tmov [rdx], word dx\n\
%endmacro\n\
%macro mxor 3\n\
\tlea rdx, mem+%2\n\tmov dx, word[rdx]\n\
\tlea rdx, mem+%3\n\txor dx, word[rdx]\n\
\tlea rdx, mem+%1\n\tmov [rdx], word dx\n\
%endmacro\n\
section .text\n\
main:\n\
\tpush rbp\n\
\tmov rbp, rsp\n\
",
    "\tlea rdx, [mem+%d]\n\tmov [rdx], word %d\n",
    "\tmmov %d, %d\n",
    "\tcmp %d, %d\n",
    "\tlea rdx, [mem+%d]\n\tcmp %d, word [rdx]\n",
    "\tlea rdx, [mem+%d]\n\tcmp [rdx], word %d\n",
    "\tmcmp word %d, %d\n",
    "\tjmp %s\n",
    "\tjnz %s\n",
    "\tjz %s\n",
    "\tjg %s\n",
    "\tjl %s\n",
    "\tlea rdx, [mem+%d]\n\tmov [rdx], word %d\n",
    "\tmov r8, %d\n\tmov r8w, %d\n\tlea rdx, [mem+%d]\n\tadd r8w, word[rdx]\n\tlea rdx, [mem+r8]\n\tmov [rdx], word r8w\n",
    "\tmov r8, %d\n\tlea rdx, [mem+%d]\n\tmov r8w, word[rdx]\n\tadd r8w, %d\n\tlea rdx, [mem+r8]\n\tmov [rdx], word r8w\n",
    "\tmadd %d, %d, %d\n",
    "\tlea rdx, [mem+%d]\n\tmov [rdx], word %d\n",
    "\tmov r8, %d\n\tmov r8w, %d\n\tlea rdx, [mem+%d]\n\tsub r8w, word[rdx]\n\tlea rdx, [mem+r8]\n\tmov [rdx], word r8w\n",
    "\tmov r8, %d\n\tlea rdx, [mem+%d]\n\tmov r8w, word[rdx]\n\tsub r8w, %d\n\tlea rdx, [mem+r8]\n\tmov [rdx], word r8w\n",
    "\tmsub %d, %d, %d\n",
    "\tlea rdx, [mem+%d]\n\tmov [rdx], word %d\n",
    "\tmov r8, %d\n\tmov r8w, %d\n\tlea rdx, [mem+%d]\n\timul r8w, word[rdx]\n\tlea rdx, [mem+r8]\n\tmov [rdx], word r8w\n",
    "\tmov r8, %d\n\tlea rdx, [mem+%d]\n\tmov r8w, word[rdx]\n\timul r8w, %d\n\tlea rdx, [mem+r8]\n\tmov [rdx], word r8w\n",
    "\tmmul %d, %d, %d\n",
    "\tlea rdx, [mem+%d]\n\tmov [rdx], word %d\n",
    "\tmov r8, %d\n\tmov r8w, %d\n\tlea rdx, [mem+%d]\n\tidiv r8w, word[rdx]\n\tlea rdx, [mem+r8]\n\tmov [rdx], word r8w\n",
    "\tmov r8, %d\n\tlea rdx, [mem+%d]\n\tmov r8w, word[rdx]\n\tidiv r8w, %d\n\tlea rdx, [mem+r8]\n\tmov [rdx], word r8w\n",
    "\tmdiv %d, %d, %d\n",
    "\tlea rdx, [mem+%d]\n\tmov [rdx], word %d\n",
    "\tmov r8, %d\n\tmov r8w, %d\n\tlea rdx, [mem+%d]\n\tand r8w, word[rdx]\n\tlea rdx, [mem+r8]\n\tmov [rdx], word r8w\n",
    "\tmov r8, %d\n\tlea rdx, [mem+%d]\n\tmov r8w, word[rdx]\n\tand r8w, %d\n\tlea rdx, [mem+r8]\n\tmov [rdx], word r8w\n",
    "\tmand %d, %d, %d\n",
    "\tlea rdx, [mem+%d]\n\tmov [rdx], word %d\n",
    "\tmov r8, %d\n\tmov r8w, %d\n\tlea rdx, [mem+%d]\n\tor r8w, word[rdx]\n\tlea rdx, [mem+r8]\n\tmov [rdx], word r8w\n",
    "\tmov r8, %d\n\tlea rdx, [mem+%d]\n\tmov r8w, word[rdx]\n\tor r8w, %d\n\tlea rdx, [mem+r8]\n\tmov [rdx], word r8w\n",
    "\tmor %d, %d, %d\n",
    "\tlea rdx, [mem+%d]\n\tmov [rdx], word %d\n",
    "\tmov r8, %d\n\tmov r8w, %d\n\tlea rdx, [mem+%d]\n\txor r8w, word[rdx]\n\tlea rdx, [mem+r8]\n\tmov [rdx], word r8w\n",
    "\tmov r8, %d\n\tlea rdx, [mem+%d]\n\tmov r8w, word[rdx]\n\txor r8w, %d\n\tlea rdx, [mem+r8]\n\tmov [rdx], word r8w\n",
    "\tmxor %d, %d, %d\n",
    "",
    "",
    "",/*NOT IMPLEMENTED*/
    "",/*NOT IMPLEMENTED*/
    "",/*NOT IMPLEMENTED*/
    "",/*NOT IMPLEMENTED*/
    "",/*NOT IMPLEMENTED*/
    "%s\n",
    "\tmov rsp, rbp\n\tpop rbp\n\tret\n",
    "\tmov rsp, rbp\n\tpop rbp\n\tret\nsection .data\nmem: times 4096 db 0\n"};

#endif // ASM_DEFINITIONS_H
