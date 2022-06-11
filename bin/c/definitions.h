#ifndef DEFINITIONS_H
#define DEFINITIONS_H

#include "c_definitions.h"
#include "asm_definitions.h"

enum
{
    DEF_HEADER = 0,
    DEF_MOV_M_V,
    DEF_MOV_M_M,
    DEF_CMP_V_V,
    DEF_CMP_V_M,
    DEF_CMP_M_V,
    DEF_CMP_M_M,
    DEF_JMP,
    DEF_JNZ,
    DEF_JEZ,
    DEF_JGZ,
    DEF_JLZ,
    DEF_ADD_V_V,
    DEF_ADD_V_M,
    DEF_ADD_M_V,
    DEF_ADD_M_M,
    DEF_SUB_V_V,
    DEF_SUB_V_M,
    DEF_SUB_M_V,
    DEF_SUB_M_M,
    DEF_MUL_V_V,
    DEF_MUL_V_M,
    DEF_MUL_M_V,
    DEF_MUL_M_M,
    DEF_DIV_V_V,
    DEF_DIV_V_M,
    DEF_DIV_M_V,
    DEF_DIV_M_M,
    DEF_AND_V_V,
    DEF_AND_V_M,
    DEF_AND_M_V,
    DEF_AND_M_M,
    DEF_OR_V_V,
    DEF_OR_V_M,
    DEF_OR_M_V,
    DEF_OR_M_M,
    DEF_XOR_V_V,
    DEF_XOR_V_M,
    DEF_XOR_M_V,
    DEF_XOR_M_M,
    DEF_NOT_M_V,
    DEF_NOT_M_M,
    DEF_PRINT,
    DEF_PRINT_INT,
    DEF_PRINT_MEM,
    DEF_PRINT_CHAR,
    DEF_PRINT_STR,
    DEF_FOOTER,
};

#endif // DEFINITIONS_H
