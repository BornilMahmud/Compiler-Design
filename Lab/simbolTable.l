%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Symbol {
    char name[50];
    int count;
} Symbol;

Symbol table[100];   /* store up to 100 unique identifiers */
int symCount = 0;

/* Function to add or update identifier in table */
void addSymbol(char *s) {
    for (int i = 0; i < symCount; i++) {
        if (strcmp(table[i].name, s) == 0) {
            table[i].count++;
            return;
        }
    }
    /* New identifier */
    strcpy(table[symCount].name, s);
    table[symCount].count = 1;
    symCount++;
}

%}

/* Flex rules */
%%
[a-zA-Z_][a-zA-Z0-9_]*   { addSymbol(yytext); }   /* identifiers */
[ \t\r\n]+               ;   /* ignore whitespace & Windows CR */
.                        ;   /* ignore any other character */
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

    yyin = fp;   /* scan from the file */
    yylex();

    /* Print symbol table */
    printf("\nSymbol Table:\n");
    printf("%-20s  Count\n", "Identifier");
    printf("------------------------\n");
    for (int i = 0; i < symCount; i++) {
        printf("%-20s  %d\n", table[i].name, table[i].count);
    }

    fclose(fp);
    return 0;
}
