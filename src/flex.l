%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdint.h>
    #include <inttypes.h>
    #include "bison.tab.h"
    extern int yylex();
    void yyerror (char const *err)
    {
        fprintf (stderr, "Line %d: %s\n", yylineno, err);
    }
%}
%option noyywrap
%option case-insensitive
%option yylineno
DIGIT [0-9]
WHITESPACE [ \t\n\r]
ALPHABET [a-zA-Z0-9_\\\%:;,. ]
%%
mov                       { return INSTRUCTION_MOV;                                                                       }
cmp                       { return INSTRUCTION_CMP;                                                                       }
jmp                       { return INSTRUCTION_JMP;                                                                       }
jnz                       { return INSTRUCTION_JNZ;                                                                       }
jez|jz                    { return INSTRUCTION_JEZ;                                                                       }
jgz|jg                    { return INSTRUCTION_JGZ;                                                                       }
jlz|jl                    { return INSTRUCTION_JLZ;                                                                       }
add                       { return INSTRUCTION_ADD;                                                                       }
sub                       { return INSTRUCTION_SUB;                                                                       }
mul                       { return INSTRUCTION_MUL;                                                                       }
div                       { return INSTRUCTION_DIV;                                                                       }
and                       { return INSTRUCTION_AND;                                                                       }
or                        { return INSTRUCTION_OR;                                                                        }
xor                       { return INSTRUCTION_XOR;                                                                       }
not                       { return INSTRUCTION_NOT;                                                                       }
print                     { return MACRO_PRINT;                                                                           }
\"                        { return QUOTE;                                                                                 }
\(                        { return BRACKET_LEFT;                                                                          }
\)                        { return BRACKET_RIGHT;                                                                         }
,                         { return SEPARATOR;                                                                             }
\;                        { return LINE_SEPARATOR;                                                                        }
\$\([0-9]+\)              { char tmp[5] = {yytext[2],yytext[3],yytext[4],yytext[5],'\0'};yylval.i = atoi(tmp);return MEM; }
\$[0-9]+                  { yylval.i = atoi(yytext+1);return MEM;                                                         }
[a-zA-Z_]+:               { yylval.str = strdup(yytext); return LABEL;                                                    }
[a-zA-Z_]+                { yylval.str = strdup(yytext); return JMP_LABEL;                                                }
{DIGIT}+\.{DIGIT}+        { yylval.i = (int)atof(yytext); return INT;                                                     }
{DIGIT}+                  { yylval.i = atoi(yytext); return INT;                                                          }
\"{ALPHABET}{ALPHABET}+\" { yylval.str = strdup(yytext); return STRING;                                                   }
\'{ALPHABET}\'            { yylval.c = yytext[1]; return CHAR;                                                            }
{WHITESPACE}              ;
.                         ;
%%