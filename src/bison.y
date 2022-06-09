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
    int32_t mem[4096];
    int32_t flag = 0;
%}

%union {
  int32_t i;
  float f;
  char c;
  char *str;
};

%token <i> INT
%token <f> FLOAT
%token <c> CHAR
%token <str> STRING

%token INSTRUCTION_MOV
%token INSTRUCTION_MOVF
%token INSTRUCTION_CMP
%token INSTRUCTION_JMP

%token MACRO_PRINT

%token QUOTE
%token BRACKET_LEFT
%token BRACKET_RIGHT
%token SEPARATOR
%token LINE_SEPARATOR

%type <i> int
%type <f> float
%type <c> char

%%
input:
  | input op LINE_SEPARATOR
  ;
op: instruction | macro | output;
instruction: mov | movf | cmp | jmp;
mov: INSTRUCTION_MOV ;
movf: INSTRUCTION_MOVF ;
cmp: INSTRUCTION_CMP ;
jmp: INSTRUCTION_JMP ;
macro: char | int | float;
char:   "char("INT")" {$$ = (char)$2;}
      | "char("CHAR")" {$$ = (char)$2;}
      | "char("FLOAT")" {$$ = (char)$2;}
;
int:   "int("CHAR")" {$$ = (int32_t)$2;}
     | "int("INT")" {$$ = (int32_t)$2;}
     | "int("FLOAT")" {$$ = (int32_t)$2;}
;
float:   "float("CHAR")" {$$ = (float)$2;}
       | "float("INT")" {$$ = (float)$2;}
       | "float("FLOAT")" {$$ = (float)$2;}
;
output:  MACRO_PRINT BRACKET_LEFT STRING  BRACKET_RIGHT         {printf("printf(\"%%s\", %s);\n", $3);}
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR INT BRACKET_RIGHT    {printf("printf(%s,%d);\n",$3, $5);  }
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR CHAR BRACKET_RIGHT   {printf("printf(%s,\'%c\');\n",$3, $5);  }
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR FLOAT BRACKET_RIGHT  {printf("printf(%s,%f);\n",$3, $5);  }
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