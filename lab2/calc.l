/* calculator #1 */
%{
    #include "calc.tab.h"
    #include <stdlib.h>
    void yyerror(char *);
%}

%%

[a-z]       {
                yylval = yytext[0] - 'a';   /* convert 'a'..'z' → 0..25 */
                return VARIABLE;
            }

[0-9]+      {
                yylval = atoi(yytext);
                return INTEGER;
            }

[-+()=/*\n]     { 
                return *yytext; 
            }

[ \t]           ;       /* skip whitespace */

.               yyerror("Unknown character");

%%

int yywrap(void) {
    return 1;
}
