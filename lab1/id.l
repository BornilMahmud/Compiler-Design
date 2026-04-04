%{
#include <stdio.h>
%}

%%
[a-zA-Z_][a-zA-Z0-9_]*     { printf("Valid identifier: %s\n", yytext); }
[0-9][a-zA-Z0-9_]*         { printf("Invalid identifier (starts with digit): %s\n", yytext); }
.|\n                       { /* ignore everything else */ }
%%

int yywrap(void)
{
    return 1;
}

int main(void)
{
    printf("Identifier Validation Program\n");
    printf("Enter identifiers (Ctrl+D to stop):\n");
    yylex();
    return 0;
}
