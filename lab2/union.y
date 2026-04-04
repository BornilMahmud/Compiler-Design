/* C Declarations */

%{
	#include<stdio.h>
	int yylex(void);
	int yyerror(char *s);
	
%}

/* bison declarations */

%token IDENTIFIER INTEGER FLOAT


/* Grammar rules and actions follow.  */

%%

%union
{
    int intValue;
    float floatValue;
    char *stringValue;
};
start: 
	| start input
	;
input:  FLOAT	{ printf("\nfloat value:%.2f\n",yylval.floatValue); }

	|INTEGER	{ printf("\ninteger value: %d\n",yylval.intValue); }
	
	|IDENTIFIER	{ printf("\nid: %s\n",yylval.stringValue);  }
	; 

%%

int yywrap()
{
return 1;
}

int main(void){
	yyparse();
	return 0;
}

int yyerror(char *s){
	printf( "%s\n", s);
	return 0;
}

