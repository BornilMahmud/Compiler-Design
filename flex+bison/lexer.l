%{
#include "parser.tab.h"
%}

%option noyywrap
%x COMMENT

%%

"int"                               { return INT; }
"return"                            { return RETURN; }
"void"                              { return VOID; }

[a-zA-Z_][a-zA-Z0-9_]*               { return IDENTIFIER; }
[0-9]+                               { return NUMBER; }

"("                                 { return LPAREN; }
")"                                 { return RPAREN; }
"{"                                 { return LBRACE; }
"}"                                 { return RBRACE; }
";"                                 { return SEMI; }
"="                                 { return ASSIGN; }
","                                 { return COMMA; }
"["                                 { return LBRACKET; }
"]"                                 { return RBRACKET; }

"\""([^\\\n]|\\.)*"\""             { return STRING; }

"//"[^\n]*                          { }
"#"[^\n]*                           { }
"/*"                                { BEGIN(COMMENT); }
<COMMENT>"*/"                       { BEGIN(INITIAL); }
<COMMENT>\n                          { }
<COMMENT>.                           { }

[ \t\r\n]+                           { }

.                                   { return OTHER; }

%%