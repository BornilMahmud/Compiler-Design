/* postfix2.y - postfix calculator */

%{
    #include <stdio.h>
    #include <stdlib.h>
    int yylex(void);
    int yyerror(const char *s);
%}

%union {
    double dval;
}

%token <dval> NUMBER
%token PLUS MINUS STAR SLASH NEWLINE
%type <dval> expr

%%
input:
      /* empty */
    | input line
    ;

line:
      NEWLINE
    | expr NEWLINE { printf("%lf\n", $1); }
    ;

expr:
      NUMBER          { $$ = $1; }
    | expr expr PLUS  { $$ = $1 + $2; }
    | expr expr MINUS { $$ = $1 - $2; }
    | expr expr STAR  { $$ = $1 * $2; }
    | expr expr SLASH { $$ = $1 / $2; }
    ;
%%

int yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}

int main(void) {
    yyparse();
    return 0;
}
