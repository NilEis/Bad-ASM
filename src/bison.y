%{
    #include <stdio.h>
    #include <stdlib.h>
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
    int use_asm = 0;
    void yyerror (char const *err);
    void print_out(char const* str);
    void print_out_i(char const* str, int i);
    void print_out_mem(char const* str, int i);
    void print_out_c(char const* str, char c);
    void print_out_str(char const* str, char const *s);
    FILE*asm_str_def = NULL;
    uint32_t asm_str_i = 0;
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
%token INSTRUCTION_EXIT

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
instruction: mov | cmp | jmp | add | sub | mul | div | and | or | xor | not | exit
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
output:  MACRO_PRINT BRACKET_LEFT STRING  BRACKET_RIGHT {print_out($3); free($3);}
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR INT BRACKET_RIGHT {print_out_i($3, $5); free($3);}
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR MEM BRACKET_RIGHT {print_out_mem($3, S($5)); free($3);}
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR CHAR BRACKET_RIGHT {print_out_c($3, $5); free($3);}
       | MACRO_PRINT BRACKET_LEFT STRING SEPARATOR STRING BRACKET_RIGHT {print_out_str($3, $5);  free($3); free($5);}
;
label: LABEL {printf(output[DEF_LABEL], $1); free($1);};
VAL:  INT {$$=$1;}
    | CHAR {$$=(int16_t)$1;}
;
exit: INSTRUCTION_EXIT {printf(output[DEF_EXIT]);};
%%

int main(int argc, char**argv) {
  FILE*f = NULL;
  for(int i = 1; i < argc; i++)
  {
    if(argv[i][0]=='-' && argv[i][1]=='f')
    {
        use_asm = !use_asm;
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
  if(!use_asm)
  {
    output = c_definitions;

  }
  else
  {
    output = asm_definitions;
    m_size = sizeof(int16_t);
    asm_str_def = tmpfile();
    if(asm_str_def==NULL)
    {
        fprintf (stderr, "Could not open tmpfile\n");
        exit(1);
    }
  }
  printf("%s",output[DEF_HEADER]);
  yyparse();
  printf("%s",output[DEF_FOOTER]);
  if(use_asm)
  {
      rewind(asm_str_def);
      char c = fgetc(asm_str_def);;
      while(c!=EOF)
      {
          putc(c,stdout);
          c = fgetc(asm_str_def);
      }
      fclose(asm_str_def);
  }
}

void print_out(char const* str)
{
    if(use_asm)
    {
        fprintf(asm_str_def, "_%"PRIu32": db ", asm_str_i);
        int i = 0;
        while(str[i]!='\0')
        {
            fprintf(asm_str_def, "%d, ", str[i]);
            i++;
        }
        fprintf(asm_str_def, "0\n");
        printf("\tpush _%"PRIu32"\n\tcall printf\n", asm_str_i);
        asm_str_i++;
    }
    else
    {
        printf(output[DEF_PRINT], str);
    }
}

void print_out_i(char const* str, int i)
{
    if(use_asm)
    {
        printf("\tpush %d\n",i);
        print_out(str);
    }
    else
    {
        printf(output[DEF_PRINT_INT],str,i);
    }
}

void print_out_mem(char const* str, int i)
{
    if(use_asm)
    {
        printf("push word[mem+%d]\n",i);
        print_out(str);
    }
    else
    {
        printf(output[DEF_PRINT_MEM],str,i);
    }
}

void print_out_c(char const* str, char c)
{
    if(use_asm)
    {
        printf("push %d\n",c);
        print_out(str);
    }
    else
    {
        printf(output[DEF_PRINT_CHAR],str,c);
    }
}

void print_out_str(char const* str, char const *s)
{
    if(use_asm)
    {
        fprintf(asm_str_def, "_%"PRIu32": db ", asm_str_i);
        int i = 0;
        while(s[i]!='\0')
        {
            fprintf(asm_str_def, "%d, ", s[i]);
            i++;
        }
        fprintf(asm_str_def, "0\n");
        printf("pushl _%"PRIu32"\n",asm_str_i);
        asm_str_i++;
        print_out(str);
    }
    else
    {
        printf(output[DEF_PRINT_STR],str,s);
    }
}
