/* postfix2.l - lexer for postfix2.y */

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "postfix2.tab.h"
    extern YYSTYPE yylval;
    int yyerror(const char *s);
%}

%option noyywrap

digit   [0-9]
number  {digit}+([.]{digit}+)?

%%
{number} {
    yylval.dval = atof(yytext);
    return NUMBER;
}
"+"      { return PLUS; }
"-"      { return MINUS; }
"*"      { return STAR; }
"/"      { return SLASH; }
"\n"     { return NEWLINE; }
[ \t]+   ;
.        { yyerror("Unknown character"); }
%%
