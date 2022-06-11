%{
    #include <stdio.h>
    #include <stdint.h>
    #include <inttypes.h>
    #include <ctype.h>
    #include <string.h>
    #include "header.h"
    #include "definitions.h"
    #define YYDEBUG 1
    #define S(x) ((x)*(m_size))
    extern int yylex();
    extern int yyparse();
    extern FILE *yyin;
    char**output;
    int m_size = 1;
    void yyerror (char const *err);
%}
%locations
%union {
  int16_t i;
  char c;
  char *str;
};

%token <i> INT
%token <i> MEM
%token <c> CHAR
%token <str> STRING
%token <str> LABEL
%token <str> JMP_LABEL

%token INSTRUCTION_MOV
%token INSTRUCTION_CMP
%token INSTRUCTION_JMP
%token INSTRUCTION_JNZ
%token INSTRUCTION_JEZ
%token INSTRUCTION_JGZ
%token INSTRUCTION_JLZ
%token INSTRUCTION_ADD
%token INSTRUCTION_SUB
%token INSTRUCTION_MUL
%token INSTRUCTION_DIV
%token INSTRUCTION_AND
%token INSTRUCTION_OR
%token INSTRUCTION_XOR
%token INSTRUCTION_NOT

%token MACRO_PRINT

%token QUOTE
%token BRACKET_LEFT
%token BRACKET_RIGHT
%token SEPARATOR
%token LINE_SEPARATOR

%type <i> VAL

%%
input:
  | input op
  ;
op: instruction LINE_SEPARATOR | output LINE_SEPARATOR | label | LINE_SEPARATOR;
instruction: mov | cmp | jmp | add | sub | mul | div | and | or | xor | not
;
mov:  INSTRUCTION_MOV MEM SEPARATOR VAL {printf(output[DEF_MOV_M_V],S($2),$4);}
    | INSTRUCTION_MOV MEM SEPARATOR MEM {printf(output[DEF_MOV_M_M],S($2),S($4));}
;
cmp:  INSTRUCTION_CMP VAL SEPARATOR VAL {printf(output[DEF_CMP_V_V], $2, $4, $2, $4);}
    | INSTRUCTION_CMP VAL SEPARATOR MEM {printf(output[DEF_CMP_V_M], $2, S($4), $2, S($4));}
    | INSTRUCTION_CMP MEM SEPARATOR VAL {printf(output[DEF_CMP_M_V], S($2), $4, S($2), $4);}
    | INSTRUCTION_CMP MEM SEPARATOR MEM {printf(output[DEF_CMP_M_M], S($2), S($4), S($2), S($4));}
;
jmp:  INSTRUCTION_JMP JMP_LABEL { printf(output[DEF_JMP],$2);free($2);            }
    | INSTRUCTION_JNZ JMP_LABEL { printf(output[DEF_JNZ],$2);free($2); }
    | INSTRUCTION_JEZ JMP_LABEL { printf(output[DEF_JEZ],$2);free($2); }
    | INSTRUCTION_JGZ JMP_LABEL { printf(output[DEF_JGZ],$2);free($2);  }
    | INSTRUCTION_JLZ JMP_LABEL { printf(output[DEF_JLZ],$2);free($2);  }
;
add:  INSTRUCTION_ADD MEM SEPARATOR VAL SEPARATOR VAL { printf(output[DEF_ADD_V_V], S($2), ($4 + $6)); }
    | INSTRUCTION_ADD MEM SEPARATOR VAL SEPARATOR MEM { printf(output[DEF_ADD_V_M], S($2), $4, S($6)); }
    | INSTRUCTION_ADD MEM SEPARATOR MEM SEPARATOR VAL { printf(output[DEF_ADD_M_V], S($2), S($4), $6); }
    | INSTRUCTION_ADD MEM SEPARATOR MEM SEPARATOR MEM { printf(output[DEF_ADD_M_M], S($2), S($4), S($6)); }
;
sub:  INSTRUCTION_SUB MEM SEPARATOR VAL SEPARATOR VAL { printf(output[DEF_SUB_V_V], S($2), ($4 - $6)); }
    | INSTRUCTION_SUB MEM SEPARATOR VAL SEPARATOR MEM { printf(output[DEF_SUB_V_M], S($2), $4, S($6)); }
    | INSTRUCTION_SUB MEM SEPARATOR MEM SEPARATOR VAL { printf(output[DEF_SUB_M_V], S($2), S($4), $6); }
    | INSTRUCTION_SUB MEM SEPARATOR MEM SEPARATOR MEM { printf(output[DEF_SUB_M_M], S($2), S($4), S($6)); }
;
mul:  INSTRUCTION_MUL MEM SEPARATOR VAL SEPARATOR VAL { printf(output[DEF_MUL_V_V], S($2), ($4 * $6)); }
    | INSTRUCTION_MUL MEM SEPARATOR VAL SEPARATOR MEM { printf(output[DEF_MUL_V_M], S($2), $4, S($6)); }
    | INSTRUCTION_MUL MEM SEPARATOR MEM SEPARATOR VAL { printf(output[DEF_MUL_M_V], S($2), S($4), $6); }
    | INSTRUCTION_MUL MEM SEPARATOR MEM SEPARATOR MEM { printf(output[DEF_MUL_M_M], S($2), S($4), S($6)); }
;
div:  INSTRUCTION_DIV MEM SEPARATOR VAL SEPARATOR VAL { printf(output[DEF_DIV_V_V], S($2), ($4 / $6)); }
    | INSTRUCTION_DIV MEM SEPARATOR VAL SEPARATOR MEM { printf(output[DEF_DIV_V_M], S($2), $4, S($6)); }
    | INSTRUCTION_DIV MEM SEPARATOR MEM SEPARATOR VAL { printf(output[DEF_DIV_M_V], S($2), S($4), $6); }
    | INSTRUCTION_DIV MEM SEPARATOR MEM SEPARATOR MEM { printf(output[DEF_DIV_M_M], S($2), S($4), S($6)); }
;
and:  INSTRUCTION_AND MEM SEPARATOR VAL SEPARATOR VAL { printf(output[DEF_AND_V_V], S($2), ($4 & $6)); }
    | INSTRUCTION_AND MEM SEPARATOR VAL SEPARATOR MEM { printf(output[DEF_AND_V_M], S($2), $4, S($6)); }
    | INSTRUCTION_AND MEM SEPARATOR MEM SEPARATOR VAL { printf(output[DEF_AND_M_V], S($2), S($4), $6); }
    | INSTRUCTION_AND MEM SEPARATOR MEM SEPARATOR MEM { printf(output[DEF_AND_M_M], S($2), S($4), S($6)); }
;
or:   INSTRUCTION_OR MEM SEPARATOR VAL SEPARATOR VAL { printf(output[DEF_OR_V_V], S($2), ($4 | $6)); }
    | INSTRUCTION_OR MEM SEPARATOR VAL SEPARATOR MEM { printf(output[DEF_OR_V_M], S($2), $4, S($6)); }
    | INSTRUCTION_OR MEM SEPARATOR MEM SEPARATOR VAL { printf(output[DEF_OR_M_V], S($2), S($4), $6); }
    | INSTRUCTION_OR MEM SEPARATOR MEM SEPARATOR MEM { printf(output[DEF_OR_M_M], S($2), S($4), S($6)); }
;
xor:  INSTRUCTION_XOR MEM SEPARATOR VAL SEPARATOR VAL { printf(output[DEF_XOR_V_V], S($2), ($4 ^ $6)); }
    | INSTRUCTION_XOR MEM SEPARATOR VAL SEPARATOR MEM { printf(output[DEF_XOR_V_M], S($2), $4, S($6)); }
    | INSTRUCTION_XOR MEM SEPARATOR MEM SEPARATOR VAL { printf(output[DEF_XOR_M_V], S($2), S($4), $6); }
    | INSTRUCTION_XOR MEM SEPARATOR MEM SEPARATOR MEM { printf(output[DEF_XOR_M_M], S($2), S($4), S($6)); }
;
not:  INSTRUCTION_NOT MEM SEPARATOR VAL { printf(output[DEF_NOT_M_V], S($2), (~$4)); }
    | INSTRUCTION_NOT MEM SEPARATOR MEM { printf(output[DEF_NOT_M_M], S($2), S($4)); }
;
output:  MACRO_PRINT BRACKET_LEFT STRING  BRACKET_RIGHT {printf(output[DEF_PRINT], $3); free($3);}
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR INT BRACKET_RIGHT {printf(output[DEF_PRINT_INT],$3, $5); free($3);}
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR MEM BRACKET_RIGHT {printf(output[DEF_PRINT_MEM],$3, S($5)); free($3);}
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR CHAR BRACKET_RIGHT {printf(output[DEF_PRINT_CHAR],$3, $5); free($3);}
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR STRING BRACKET_RIGHT {printf(output[DEF_PRINT_STR],$3, $5);  free($3);}
;
label: LABEL {printf("%s\n", $1); free($1);};
VAL:  INT {$$=$1;}
    | CHAR {$$=(int16_t)$1;}
;
%%

int main(int argc, char**argv) {
  FILE*f = NULL;
  int fasm = 0;
  for(int i = 1; i < argc; i++)
  {
    if(argv[i][0]=='-' && argv[i][1]=='f')
    {
        fasm = !fasm;
    }
    else
    {
        f = fopen(argv[i], "r");
        if(f==NULL)
        {
            printf("Could not open file\n");
            return -1;
        }
        yyin = f;
    }
  }
  if(!fasm)
  {
    output = c_definitions;
  }
  else
  {
    output = asm_definitions;
    m_size = sizeof(int16_t);
  }
  printf("%s",output[DEF_HEADER]);
  yyparse();
  printf("%s",output[DEF_FOOTER]);
}