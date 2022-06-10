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

%token MACRO_PRINT

%token QUOTE
%token BRACKET_LEFT
%token BRACKET_RIGHT
%token SEPARATOR
%token LINE_SEPARATOR

%%
input:
  | input op
  ;
op: instruction LINE_SEPARATOR | output LINE_SEPARATOR | label;
instruction: mov | cmp | jmp;
mov: INSTRUCTION_MOV ;
cmp: INSTRUCTION_CMP ;
jmp:  INSTRUCTION_JMP JMP_LABEL { printf("\tgoto %s;\n",$2);free($2);            }
    | INSTRUCTION_JNZ JMP_LABEL { printf("\tif(flag!=0)goto %s;\n",$2);free($2); }
    | INSTRUCTION_JEZ JMP_LABEL { printf("\tif(flag==0)goto %s;\n",$2);free($2); }
    | INSTRUCTION_JGZ JMP_LABEL { printf("\tif(flag>0)goto %s;\n",$2);free($2);  }
    | INSTRUCTION_JLZ JMP_LABEL { printf("\tif(flag<0)goto %s;\n",$2);free($2);  }
;
output:  MACRO_PRINT BRACKET_LEFT STRING  BRACKET_RIGHT {printf("\tprintf(\"%%s\", %s);\n", $3); free($3);}
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR INT BRACKET_RIGHT {printf("\tprintf(%s,%d);\n",$3, $5); free($3);}
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR CHAR BRACKET_RIGHT {printf("\tprintf(%s,\'%c\');\n",$3, $5); free($3);}
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR STRING BRACKET_RIGHT {printf("\tprintf(%s,%s);\n",$3, $5);  free($3);}
;
label: LABEL {printf("%s\n", $1); free($1);};
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
{\n\tint16_t mem[4096];\n\tint16_t flag = 0;\n\n",header_str);
  yyparse();
  printf("}\n");
}

void yyerror (char const *err)
{
  fprintf (stderr, "%s\n", err);
}