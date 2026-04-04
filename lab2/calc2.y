%{

    #include <stdio.h> 
    void yyerror(char *s);
    int sym[26];
%}

%code provides {
    int yylex(void);
}

%token INTEGER VARIABLE

%left '+' '-'
%left '*' '/'

%%

program:
    program line
    | /* empty */
    ;

line:
    '\n'
    | statement '\n'
    ;

statement:
      expression                { printf("%d\n", $1); }
    | VARIABLE '=' expression   { sym[$1] = $3; }
    ;

expression:
      INTEGER
    | VARIABLE                  { $$ = sym[$1]; }
    | expression '+' expression { $$ = $1 + $3; }
    | expression '-' expression { $$ = $1 - $3; }
    | expression '*' expression { $$ = $1 * $3; }
    | expression '/' expression { $$ = $1 / $3; }
    | '(' expression ')'        { $$ = $2; }
    ;
%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
}
