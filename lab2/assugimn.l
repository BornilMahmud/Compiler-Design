/* assugimn.l - lexer for assugimn.y */

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "assugimn.tab.h"
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
