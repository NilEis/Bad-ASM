#ifndef ASM_DEFINITIONS_H
#define ASM_DEFINITIONS_H

char *asm_definitions[] = {
    "\
format PE\n\
use32\n\
entry main\n\
macro mmov dest,src\n\
{\n\
\tmov dx, word[mem+src]\n\
\tmov word[mem+dest], dx\n\
}\n\
macro mcmp dest,src\n\
{\n\
\tmov dx, word[mem+src]\n\
\tcmp word[mem+dest], dx\n\
}\n\
macro madd dest,srca, srcb\n\
{\n\
\tmov dx, word[mem+srca]\n\
\tadd dx, word[mem+srcb]\n\
\tmov word[mem+dest], dx\n\
}\n\
macro msub dest,srca, srcb\n\
{\n\
\tmov dx, word[mem+srca]\n\
\tsub dx, word[mem+srcb]\n\
\tmov word[mem+dest], dx\n\
}\n\
macro mmul dest,srca, srcb\n\
{\n\
\tmov dx, word[mem+srca]\n\
\timul dx, word[mem+srcb]\n\
\tmov word[mem+dest], dx\n\
}\n\
macro mdiv dest,srca, srcb\n\
{\n\
\tmov dx, word[mem+srca]\n\
\tidiv dx, word[mem+srcb]\n\
\tmov word[mem+dest], dx\n\
}\n\
macro mand dest,srca, srcb\n\
{\n\
\tmov dx, word[mem+srca]\n\
\tand dx, word[mem+srcb]\n\
\tmov word[mem+dest], dx\n\
}\n\
macro mor dest,srca, srcb\n\
{\n\
\tmov dx, word[mem+srca]\n\
\tor dx, word[mem+srcb]\n\
\tmov word[mem+dest], dx\n\
}\n\
macro mxor dest,srca, srcb\n\
{\n\
\tmov dx, word[mem+srca]\n\
\txor dx, word[mem+srcb]\n\
\tmov word[mem+dest], dx\n\
}\n\
section '.text' code readable executable\n\
main:\n\
",
    "\tmov word[mem+%d], %d\n",
    "\tmmov %d, %d\n",
    "\tcmp %d, %d",
    "\tcmp %d, word [mem+%d]",
    "\tcmp word [mem+%d], %d",
    "\tmcmp word %d, %d",
    "\tjmp %s",
    "\tjnz %s",
    "\tjz %s",
    "\tjg %s",
    "\tjl %s",
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
    "",/*NOT IMPLEMENTED*/
    "",/*NOT IMPLEMENTED*/
    "",/*NOT IMPLEMENTED*/
    "",/*NOT IMPLEMENTED*/
    "",/*NOT IMPLEMENTED*/
    "%s\n",
    "",/*NOT IMPLEMENTED*/
    "section '.data' data readable writeable\nmem: dw 4096 dup 0\n"};

#endif // ASM_DEFINITIONS_H
