%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdint.h>
    #include <inttypes.h>
    #include "bison.tab.h"
    extern int yylex();
%}
%option noyywrap
DIGIT [0-9]
WHITESPACE [ \t\n\r]
ALPHABET [a-zA-Z0-9_\\\%:;,. ]
%%
mov     {return INSTRUCTION_MOV;}
movf    {return INSTRUCTION_MOVF;}
cmp     {return INSTRUCTION_CMP;}
jmp     {return INSTRUCTION_JMP;}
print   {return MACRO_PRINT;}
\"      {return QUOTE;}
\(      {return BRACKET_LEFT;}
\)      {return BRACKET_RIGHT;}
,       {return SEPARATOR;}
;       {return LINE_SEPARATOR;}
{DIGIT}+\.{DIGIT}+    { yylval.f = atof(yytext); return FLOAT;      }
{DIGIT}+            { yylval.i = atoi(yytext); return INT;        }
\"{ALPHABET}{ALPHABET}+\"      { yylval.str = strdup(yytext); return STRING; }
\'{ALPHABET}\'       { yylval.c = yytext[1]; return CHAR;        }
{WHITESPACE}        ;
. ;
%%