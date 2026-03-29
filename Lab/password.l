%option noyywrap
%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>

int hasUpper, hasDigit;
%}

%%

[A-Za-z0-9!@#$%^&*()_+=-]+ {
    /* Check the password */
    hasUpper = 0;
    hasDigit = 0;
    int len = strlen(yytext);

    for (int i = 0; i < len; i++) {
        if (isupper(yytext[i])) hasUpper = 1;
        if (isdigit(yytext[i])) hasDigit = 1;
    }

    if (len < 8 || !hasUpper || !hasDigit)
        printf("Weak password: %s\n", yytext);
    else
        printf("Strong password: %s\n", yytext);
}

[\r\t ]+ ;        /* ignore spaces, tabs, Windows \r */
\n     { return 0; }  /* stop scanning on Enter */

.      { printf("Invalid character in password: %s\n", yytext); return 0; }

%%

int main() {
    printf("Enter password:\n");
    yylex();
    return 0;
}
