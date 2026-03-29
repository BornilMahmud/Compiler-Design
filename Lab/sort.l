%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>

#define MAX 100

int numbers[MAX];
int count = 0;

/* Function to sort using Bubble Sort */
void sortNumbers() {
    for(int i = 0; i < count - 1; i++) {
        for(int j = 0; j < count - i - 1; j++) {
            if(numbers[j] > numbers[j + 1]) {
                int temp = numbers[j];
                numbers[j] = numbers[j + 1];
                numbers[j + 1] = temp;
            }
        }
    }
}
%}

%%

[0-9]+    {
              if(count < MAX) {
                  numbers[count++] = atoi(yytext);
              }
          }

[ \t\n]+   ;   /* Ignore whitespace */

.          ;   /* Ignore other characters */

%%

int main() {
    printf("Enter integers (Ctrl+D to finish input):\n");
    yylex();

    sortNumbers();

    printf("\nSorted Numbers:\n");
    for(int i = 0; i < count; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}
