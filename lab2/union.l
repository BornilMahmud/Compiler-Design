/* C Declarations */

%{
	#include<stdio.h>
	#include "union.tab.h"
	#include<stdlib.h>
	#include<string.h>
	int yyerror(char *s);
	
%}

/* RE and Actions */

%%

[a-zA-Z][a-zA-Z0-9]* {
 yylval.stringValue = strdup(yytext);
 return IDENTIFIER;
}

[0-9]+ { 
 yylval.intValue = atoi(yytext);
 return INTEGER;
}

[0-9]*\.[0-9]+"f"? {
    yylval.floatValue = atof(yytext);
 return FLOAT;
}

[ \t\n]*	

.	{
		yyerror("Unknown Character.\n");
	}
%%

