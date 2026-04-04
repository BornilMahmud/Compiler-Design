/* ssumin.y - character-class counter */

%{
    #include <stdio.h>
    int yylex(void);
    int yyerror(char *s);
    extern int vowelCount;
    extern int consonantCount;
    extern int digitCount;
    extern int spaceCount;
    extern int specialCount;
%}

%token LETTER DIGIT SPACE SPECIAL NEWLINE

%%

program:
      program unit
    | /* empty */
    ;

unit:
      LETTER
    | DIGIT
    | SPACE
    | SPECIAL
    | NEWLINE
    ;
%%

int yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}

int main(void) {
    yyparse();
    printf("vowels: %d\n", vowelCount);
    printf("consonants: %d\n", consonantCount);
    printf("digits: %d\n", digitCount);
    printf("spaces: %d\n", spaceCount);
    printf("specials: %d\n", specialCount);
    return 0;
}
