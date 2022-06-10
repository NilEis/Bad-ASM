%{
    #include <stdio.h>
    #include <stdint.h>
    #include <inttypes.h>
    #include <ctype.h>
    #include <string.h>
    #include "header.h"
    #define YYDEBUG 1
    extern int yylex();
    extern int yyparse();
    extern FILE *yyin;
    void yyerror (char const *err);
%}

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
instruction: mov | cmp | jmp | add
;
mov:  INSTRUCTION_MOV MEM SEPARATOR VAL {printf("\tmem[%d]=%d;\n",$2,$4);}
    | INSTRUCTION_MOV MEM SEPARATOR MEM {printf("\tmem[%d]=mem[%d];\n",$2,$4);}
;
cmp:  INSTRUCTION_CMP VAL SEPARATOR VAL {printf("\tflag=(%d<%d)*(-1)+(%d>%d)*1;\n", $2, $4, $2, $4);}
    | INSTRUCTION_CMP VAL SEPARATOR MEM {printf("\tflag=(%d<mem[%d])*(-1)+(%d>mem[%d])*1;\n", $2, $4, $2, $4);}
    | INSTRUCTION_CMP MEM SEPARATOR VAL {printf("\tflag=(mem[%d]<%d)*(-1)+(mem[%d]>%d)*1;\n", $2, $4, $2, $4);}
    | INSTRUCTION_CMP MEM SEPARATOR MEM {printf("\tflag=(mem[%d]<mem[%d])*(-1)+(mem[%d]>mem[%d])*1;\n", $2, $4, $2, $4);}
;
jmp:  INSTRUCTION_JMP JMP_LABEL { printf("\tgoto %s;\n",$2);free($2);            }
    | INSTRUCTION_JNZ JMP_LABEL { printf("\tif(flag!=0)goto %s;\n",$2);free($2); }
    | INSTRUCTION_JEZ JMP_LABEL { printf("\tif(flag==0)goto %s;\n",$2);free($2); }
    | INSTRUCTION_JGZ JMP_LABEL { printf("\tif(flag>0)goto %s;\n",$2);free($2);  }
    | INSTRUCTION_JLZ JMP_LABEL { printf("\tif(flag<0)goto %s;\n",$2);free($2);  }
;
add:  INSTRUCTION_ADD MEM SEPARATOR VAL SEPARATOR VAL { printf("\tmem[%d] = %d+%d;\n", $2, ($4 + $6)); }
    | INSTRUCTION_ADD MEM SEPARATOR VAL SEPARATOR MEM { printf("\tmem[%d] = %d+mem[%d];\n", $2, $4, $6); }
    | INSTRUCTION_ADD MEM SEPARATOR MEM SEPARATOR VAL { printf("\tmem[%d] = mem[%d]+%d;\n", $2, $4, $6); }
    | INSTRUCTION_ADD MEM SEPARATOR MEM SEPARATOR MEM { printf("\tmem[%d] = mem[%d]+mem[%d];\n", $2, $4, $6); }
;
sub:  INSTRUCTION_SUB MEM SEPARATOR VAL SEPARATOR VAL { printf("\tmem[%d] = %d;\n", $2, ($4 - $6)); }
    | INSTRUCTION_SUB MEM SEPARATOR VAL SEPARATOR MEM { printf("\tmem[%d] = %d-mem[%d];\n", $2, $4, $6); }
    | INSTRUCTION_SUB MEM SEPARATOR MEM SEPARATOR VAL { printf("\tmem[%d] = mem[%d]-%d;\n", $2, $4, $6); }
    | INSTRUCTION_SUB MEM SEPARATOR MEM SEPARATOR MEM { printf("\tmem[%d] = mem[%d]-mem[%d];\n", $2, $4, $6); }
;
mul:  INSTRUCTION_MUL MEM SEPARATOR VAL SEPARATOR VAL { printf("\tmem[%d] = %d;\n", $2, ($4 * $6)); }
    | INSTRUCTION_MUL MEM SEPARATOR VAL SEPARATOR MEM { printf("\tmem[%d] = %d*mem[%d];\n", $2, $4, $6); }
    | INSTRUCTION_MUL MEM SEPARATOR MEM SEPARATOR VAL { printf("\tmem[%d] = mem[%d]*%d;\n", $2, $4, $6); }
    | INSTRUCTION_MUL MEM SEPARATOR MEM SEPARATOR MEM { printf("\tmem[%d] = mem[%d]*mem[%d];\n", $2, $4, $6); }
;
div:  INSTRUCTION_DIV MEM SEPARATOR VAL SEPARATOR VAL { printf("\tmem[%d] = %d;\n", $2, ($4 / $6)); }
    | INSTRUCTION_DIV MEM SEPARATOR VAL SEPARATOR MEM { printf("\tmem[%d] = %d/mem[%d];\n", $2, $4, $6); }
    | INSTRUCTION_DIV MEM SEPARATOR MEM SEPARATOR VAL { printf("\tmem[%d] = mem[%d]/%d;\n", $2, $4, $6); }
    | INSTRUCTION_DIV MEM SEPARATOR MEM SEPARATOR MEM { printf("\tmem[%d] = mem[%d]/mem[%d];\n", $2, $4, $6); }
;
and:  INSTRUCTION_AND MEM SEPARATOR VAL SEPARATOR VAL { printf("\tmem[%d] = %d;\n", $2, ($4 & $6)); }
    | INSTRUCTION_AND MEM SEPARATOR VAL SEPARATOR MEM { printf("\tmem[%d] = %d&mem[%d];\n", $2, $4, $6); }
    | INSTRUCTION_AND MEM SEPARATOR MEM SEPARATOR VAL { printf("\tmem[%d] = mem[%d]&%d;\n", $2, $4, $6); }
    | INSTRUCTION_AND MEM SEPARATOR MEM SEPARATOR MEM { printf("\tmem[%d] = mem[%d]&mem[%d];\n", $2, $4, $6); }
;
or:   INSTRUCTION_OR MEM SEPARATOR VAL SEPARATOR VAL { printf("\tmem[%d] = %d;\n", $2, ($4 | $6)); }
    | INSTRUCTION_OR MEM SEPARATOR VAL SEPARATOR MEM { printf("\tmem[%d] = %d|mem[%d];\n", $2, $4, $6); }
    | INSTRUCTION_OR MEM SEPARATOR MEM SEPARATOR VAL { printf("\tmem[%d] = mem[%d]|%d;\n", $2, $4, $6); }
    | INSTRUCTION_OR MEM SEPARATOR MEM SEPARATOR MEM { printf("\tmem[%d] = mem[%d]|mem[%d];\n", $2, $4, $6); }
;
xor:  INSTRUCTION_XOR MEM SEPARATOR VAL SEPARATOR VAL { printf("\tmem[%d] = %d;\n", $2, ($4 ^ $6)); }
    | INSTRUCTION_XOR MEM SEPARATOR VAL SEPARATOR MEM { printf("\tmem[%d] = %d^mem[%d];\n", $2, $4, $6); }
    | INSTRUCTION_XOR MEM SEPARATOR MEM SEPARATOR VAL { printf("\tmem[%d] = mem[%d]^%d;\n", $2, $4, $6); }
    | INSTRUCTION_XOR MEM SEPARATOR MEM SEPARATOR MEM { printf("\tmem[%d] = mem[%d]^mem[%d];\n", $2, $4, $6); }
;
not:  INSTRUCTION_NOT MEM SEPARATOR VAL { printf("\tmem[%d] = %d;\n", $2, (~$4)); }
    | INSTRUCTION_NOT MEM SEPARATOR MEM { printf("\tmem[%d] = ~mem[%d];\n", $2, $4); }
;
output:  MACRO_PRINT BRACKET_LEFT STRING  BRACKET_RIGHT {printf("\tprintf(\"%%s\", %s);\n", $3); free($3);}
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR INT BRACKET_RIGHT {printf("\tprintf(%s,%d);\n",$3, $5); free($3);}
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR CHAR BRACKET_RIGHT {printf("\tprintf(%s,\'%c\');\n",$3, $5); free($3);}
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR STRING BRACKET_RIGHT {printf("\tprintf(%s,%s);\n",$3, $5);  free($3);}
;
label: LABEL {printf("%s\n", $1); free($1);};
VAL:  INT {$$=$1;}
    | CHAR {$$=(int16_t)$1;}
;
%%

int main(int argc, char**argv) {
  FILE*f = NULL;
  if(argc>1)
  {
      f = fopen(argv[1], "r");
      if(f==NULL)
      {
          printf("Could not open file\n");
          return -1;
      }
      yyin = f;
  }
  printf("\
#include <stdint.h>\n\
#include <stdio.h>\n\
#include <stdlib.h>\n\
%s\n\
int main(int argc, char** argv)\n\
{\n\tint16_t mem[4096];\n\tint16_t flag = 0;\n\n","",header_str);
  yyparse();
  printf("}\n");
}

void yyerror (char const *err)
{
  fprintf (stderr, "%s\n", err);
}