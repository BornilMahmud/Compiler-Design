%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

double value = 0;
double lhs   = 0;
double rhs   = 0;
char op = 0;
int expect_pow_rhs = 0;
%}

%%
[0-9]+(\.[0-9]+)? {
    double num = atof(yytext);

    if (op == 0 && !expect_pow_rhs) {
        value = num;
    }
    else if (op == '+' || op == '-' || op == '*' || op == '/') {
        switch (op) {
            case '+': value += num; break;
            case '-': value -= num; break;
            case '*': value *= num; break;
            case '/': value /= num; break;
        }
        op = 0;
    }
    else if (expect_pow_rhs) {
        rhs = num;
        value = pow(lhs, rhs);
        expect_pow_rhs = 0;
    }
}

"+"|"-"|"*"|"/" {
    op = yytext[0];
}

"sqrt" {
    op = 's';
}

"pow" {
    lhs = value;
    expect_pow_rhs = 1;
}
[ \t]    ;
\n {
    return 0;   /* STOP scanning on Enter */
}

. {
    printf("Invalid token: %s\n", yytext);
}
%%
int yywrap() {
    return 1;
}

int main() {
    printf("Enter expression:\n");
    yylex();

    if (op == 's') {
        value = sqrt(value);
    }

    printf("Result = %.2f\n", value);
    return 0;
}
