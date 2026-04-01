%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyparse(void);
void yyerror(const char *s);

typedef struct yy_buffer_state *YY_BUFFER_STATE;
YY_BUFFER_STATE yy_scan_string(const char *yy_str);
void yy_delete_buffer(YY_BUFFER_STATE buffer);

static int has_syntax_error = 0;

static int is_basic_c_program(const char *src) {
    if (!src) {
        return 0;
    }

    if (strstr(src, "int main") == NULL) {
        return 0;
    }
    if (strchr(src, '{') == NULL || strrchr(src, '}') == NULL) {
        return 0;
    }
    if (strstr(src, "return") == NULL) {
        return 0;
    }

    return 1;
}

static char *read_stdin_all(void) {
    size_t cap = 1024;
    size_t len = 0;
    int c;
    char *buf = (char *)malloc(cap);

    if (!buf) {
        return NULL;
    }

    while ((c = getchar()) != EOF) {
        if (len + 1 >= cap) {
            size_t new_cap = cap * 2;
            char *new_buf = (char *)realloc(buf, new_cap);
            if (!new_buf) {
                free(buf);
                return NULL;
            }
            buf = new_buf;
            cap = new_cap;
        }
        buf[len++] = (char)c;
    }

    buf[len] = '\0';
    return buf;
}
%}

%token INT RETURN VOID IDENTIFIER NUMBER STRING OTHER
%token LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN COMMA LBRACKET RBRACKET

%%

program:
    token_stream
    ;

token_stream:
    | token_stream token
    ;

token:
    INT
    | RETURN
    | VOID
    | IDENTIFIER
    | NUMBER
    | STRING
    | LPAREN
    | RPAREN
    | LBRACE
    | RBRACE
    | SEMI
    | ASSIGN
    | COMMA
    | LBRACKET
    | RBRACKET
    | OTHER
    ;

%%

void yyerror(const char *s) {
    (void)s;
    has_syntax_error = 1;
}

int main(void) {
    char *input;
    YY_BUFFER_STATE buffer;
    int parse_result;

    printf("Enter C code (paste and press Ctrl+Z then Enter):\n");
    input = read_stdin_all();

    if (!input) {
        fprintf(stderr, "Failed to read input.\n");
        return 1;
    }

    printf("Detected Language: C\n");

    buffer = yy_scan_string(input);
    parse_result = yyparse();
    yy_delete_buffer(buffer);

    if (parse_result == 0 && !has_syntax_error && is_basic_c_program(input)) {
        printf("C Executed Output: Valid C Program\n");
    } else {
        printf("C Executed Output: Syntax Error\n");
    }

    free(input);
    return 0;
}