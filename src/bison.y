%{
    #include <stdio.h>
    #include <stdint.h>
    #include <inttypes.h>
    #include <ctype.h>
    #include <string.h>
    #define YYDEBUG 1
    extern int yylex();
    extern int yyparse();
    extern FILE *yyin;
    void yyerror (char const *err);
    int16_t mem[4096];
    int16_t flag = 0;
%}

%union {
  int16_t i;
  char c;
  char *str;
};

%token <i> INT
%token <c> CHAR
%token <str> STRING

%token INSTRUCTION_MOV
%token INSTRUCTION_CMP
%token INSTRUCTION_JMP

%token MACRO_PRINT

%token QUOTE
%token BRACKET_LEFT
%token BRACKET_RIGHT
%token SEPARATOR
%token LINE_SEPARATOR

%%
input:
  | input op LINE_SEPARATOR
  ;
op: instruction | output;
instruction: mov | cmp | jmp;
mov: INSTRUCTION_MOV ;
cmp: INSTRUCTION_CMP ;
jmp: INSTRUCTION_JMP ;
output:  MACRO_PRINT BRACKET_LEFT STRING  BRACKET_RIGHT         {printf("printf(\"%%s\", %s);\n", $3);}
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR INT BRACKET_RIGHT    {printf("printf(%s,%d);\n",$3, $5);  }
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR CHAR BRACKET_RIGHT   {printf("printf(%s,\'%c\');\n",$3, $5);  }
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR STRING BRACKET_RIGHT {printf("printf(%s,%s);\n",$3, $5);  }
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
  yyparse();
}

void yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}