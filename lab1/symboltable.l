%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;

typedef struct {
    char name[50];
    int count;
} Symbol;

Symbol table[100];
int symCount = 0;

void addSymbol(char *s) {
    for (int i = 0; i < symCount; i++) {
        if (strcmp(table[i].name, s) == 0) {
            table[i].count++;
            return;
        }
    }

    if (symCount < 100) {
        strncpy(table[symCount].name, s, 49);
        table[symCount].name[49] = '\0';
        table[symCount].count = 1;
        symCount++;
    }
}
%}

%%

[a-zA-Z_][a-zA-Z0-9_]*   { addSymbol(yytext); }
[ \t\r\n]+               ;
.                        ;

%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s sourcefile\n", argv[0]);
        return 1;
    }

    FILE *fp = fopen(argv[1], "r");
    if (!fp) {
        perror("Error opening file");
        return 1;
    }

    yyin = fp;
    yylex();

    printf("\nSymbol Table:\n");
    printf("%-20s  Count\n", "Identifier");
    printf("------------------------\n");

    for (int i = 0; i < symCount; i++) {
        printf("%-20s  %d\n", table[i].name, table[i].count);
    }

    fclose(fp);
    return 0;
}