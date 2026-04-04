/* ssumin.l - lexer for ssumin.y */

%{
    #include "ssumin.tab.h"
    #include <ctype.h>
    void yyerror(char *);
    int vowelCount = 0;
    int consonantCount = 0;
    int digitCount = 0;
    int spaceCount = 0;
    int specialCount = 0;

    static int is_vowel(int ch) {
        ch = tolower(ch);
        return ch == 'a' || ch == 'e' || ch == 'i' || ch == 'o' || ch == 'u';
    }
%}

%%

[a-zA-Z]    {
                if (is_vowel(yytext[0])) {
                    vowelCount++;
                } else {
                    consonantCount++;
                }
                return LETTER;
            }

[0-9]       {
                digitCount++;
                return DIGIT;
            }

[ \t]      {
                spaceCount++;
                return SPACE;
            }

[\r\n]     {
                return NEWLINE;
            }

.           {
                specialCount++;
                return SPECIAL;
            }

%%

int yywrap(void) {
    return 1;
}
