%{
#include <stdio.h>
%}

%%
[ \t\n]+                 ; /* ignore whitespace */
0                        { printf("zero\n"); }
[+]?[1-9][0-9]*          { printf("positive integer\n"); }
-[1-9][0-9]*             { printf("negative integer\n"); }
.                        { printf("invalid input: %s\n", yytext); }
%%

int yywrap(void)
{
    return 1;
}

int main(void)
{
    printf("Integer Sign Recognition (positive, negative, zero)\n");
    yylex();
    return 0;
}
