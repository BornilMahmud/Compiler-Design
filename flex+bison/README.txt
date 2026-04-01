BNL COMPILER (FLEX + BISON + C) - COMPLETE GUIDE
=================================================

1) PROJECT OVERVIEW
-------------------
BNL Compiler is a mini prototype compiler built using:
- Flex (Lex) for lexical analysis (tokenizing input)
- Bison (Yacc) for parsing token stream
- GCC for compiling generated C code

This project is for syntax detection of basic C-like structure, not a full C compiler.

Current behavior:
- Reads C code from standard input (stdin)
- Detects language as C
- Prints either:
  - C Executed Output: Valid C Program
  - C Executed Output: Syntax Error

Also included:
- Interactive playground script to:
  1. Paste code
  2. Validate using BNL compiler
  3. Compile pasted code with GCC
  4. Run compiled program and let user enter runtime values (scanf input)


2) REQUIRED TOOLS (WINDOWS)
---------------------------
You need these installed:
- Flex
- Bison
- GCC (MinGW or MinGW-w64)
- PowerShell (already included in Windows)

Recommended setup options:
Option A (Current project style):
- bison.exe
- flex.exe
- gcc.exe

Option B (WinFlexBison style):
- win_bison.exe
- win_flex.exe
- gcc.exe


3) INSTALLATION FROM SCRATCH
----------------------------
3.1 Install GCC (MinGW-w64)
- Install MinGW-w64 distribution.
- Ensure gcc.exe exists (example path):
  C:\mingw64\bin\gcc.exe

3.2 Install Flex + Bison
- Install Flex/Bison package for Windows.
- Common path example:
  C:\GnuWin32\bin\bison.exe
  C:\GnuWin32\bin\flex.exe

3.3 Add to PATH environment variable
Method A: GUI
1. Open Start -> search "Environment Variables"
2. Open "Edit the system environment variables"
3. Click "Environment Variables"
4. Under User variables (or System variables), edit "Path"
5. Add:
   - C:\mingw64\bin
   - C:\GnuWin32\bin
6. Click OK and reopen terminal

Method B: Command line (PowerShell, user PATH)
- setx PATH "$env:PATH;C:\mingw64\bin;C:\GnuWin32\bin"
- Close terminal and open new terminal

3.4 Verify installation
Run:
- gcc --version
- bison --version
- flex --version

If you use WinFlexBison package, verify:
- win_bison --version
- win_flex --version


4) PROJECT FILES
----------------
Main files:
- lexer.l       -> Flex lexer rules
- parser.y      -> Bison parser rules + main entry
- run_bnl.ps1   -> Interactive playground (detect + compile + run)
- run_bnl.bat   -> Easy launcher for PowerShell script
- input.c       -> Example C input program
- README.txt    -> This complete documentation

Generated files (created during build):
- lex.yy.c
- parser.tab.c
- parser.tab.h

Output binary:
- bnl_compiler.exe


5) HOW TO BUILD THE BNL COMPILER
--------------------------------
Open terminal in project folder:
F:\Programming\Programming\C\flex+bison

Build commands (current setup):
1. bison -d parser.y
2. flex lexer.l
3. gcc lex.yy.c parser.tab.c -o bnl_compiler.exe

If your machine uses WinFlexBison names:
1. win_bison -d parser.y
2. win_flex lexer.l
3. gcc lex.yy.c parser.tab.c -o bnl_compiler.exe


6) HOW TO RUN
-------------
6.1 Syntax detection mode only
Command:
- .\bnl_compiler.exe

Then paste C code and end input with:
- Ctrl+Z then Enter

6.2 Pipe from file
- Get-Content .\input.c | .\bnl_compiler.exe

6.3 Full interactive playground (detect + compile + execute)
Recommended:
- .\run_bnl.bat
or
- .\run_bnl.ps1

Flow:
1. Paste C code
2. Type END on a new line
3. Script validates with BNL compiler
4. Script compiles code using gcc
5. Script runs executable
6. Enter runtime values when scanf asks


7) HOW THE PROJECT WORKS (ARCHITECTURE)
----------------------------------------
Pipeline:
1. User provides C code text
2. parser.y main() reads full stdin into memory
3. yy_scan_string loads text into Flex scanner buffer
4. Flex (lexer.l) returns tokens to Bison parser
5. Bison grammar accepts token stream
6. Extra structural check ensures code contains:
   - int main
   - { and }
   - return
7. Output message printed
8. Optional script compiles user code and executes it


8) CODE EXPLANATION - parser.y (LINE BY LINE)
----------------------------------------------
Below is a practical line-by-line explanation by sequence.

A) Prologue block (%{ ... %})
- Includes stdio.h, stdlib.h, string.h for I/O, memory, string search.
- Declares yylex(), yyparse(), yyerror() prototypes.
- Declares YY_BUFFER_STATE and scanner buffer functions:
  - yy_scan_string
  - yy_delete_buffer
- Defines global flag: has_syntax_error = 0

B) is_basic_c_program(const char *src)
- Returns 0 if src is null.
- Uses strstr(src, "int main") to check main function signature text exists.
- Uses strchr(src, '{') and strrchr(src, '}') to check braces exist.
- Uses strstr(src, "return") to ensure return statement exists.
- Returns 1 only if all checks pass.

C) read_stdin_all()
- Allocates dynamic buffer with initial capacity 1024.
- Reads chars from getchar() until EOF.
- Auto-resizes buffer via realloc when needed.
- Null-terminates string and returns pointer.
- Returns NULL on allocation failure.

D) %token declarations
- Defines all token names parser can receive:
  INT, RETURN, VOID, IDENTIFIER, NUMBER, STRING, OTHER,
  LPAREN, RPAREN, LBRACE, RBRACE, SEMI, ASSIGN, COMMA, LBRACKET, RBRACKET

E) Grammar section
- program: token_stream ;
  Meaning: entire input is accepted as sequence of valid tokens.
- token_stream:
  - empty alternative (via leading |)
  - or token_stream token (repeated tokens)
- token:
  - whitelist of all acceptable token types.

F) yyerror(const char *s)
- Ignores incoming message argument.
- Sets has_syntax_error = 1.

G) main(void)
- Declares input buffer, scanner buffer, parse result variable.
- Prints prompt: "Enter C code ..."
- Reads stdin text using read_stdin_all().
- If input fails, prints error and exits.
- Prints "Detected Language: C".
- Sends full input string to Flex scanner via yy_scan_string.
- Calls yyparse() to parse token stream.
- Frees scanner buffer with yy_delete_buffer.
- Final decision:
  Valid only if:
  - yyparse() == 0
  - has_syntax_error == 0
  - is_basic_c_program(input) == 1
- Prints final output line.
- Frees input memory and exits 0.


9) CODE EXPLANATION - lexer.l (LINE BY LINE)
---------------------------------------------
A) Prologue block
- Includes parser.tab.h so token constants match parser.y.

B) Flex options
- %option noyywrap -> prevents needing yywrap() implementation.
- %x COMMENT -> defines exclusive state for block comments.

C) Token rules
- "int" -> return INT
- "return" -> return RETURN
- "void" -> return VOID
- [a-zA-Z_][a-zA-Z0-9_]* -> return IDENTIFIER
- [0-9]+ -> return NUMBER
- Symbol mappings:
  ( ) { } ; = , [ ] -> LPAREN, RPAREN, LBRACE, ...
- String literal pattern -> return STRING

D) Ignore/comment rules
- "//"[^\n]* -> ignore single-line comments
- "#"[^\n]* -> ignore preprocessor lines (#include, #define)
- "/*" -> enter COMMENT state
- <COMMENT>"*/" -> exit COMMENT state
- <COMMENT>\n and <COMMENT>. -> consume comment content
- [ \t\r\n]+ -> ignore whitespace

E) Fallback rule
- . -> return OTHER
  This prevents scanner crash on unknown symbols by mapping to generic token.


10) CODE EXPLANATION - run_bnl.ps1
----------------------------------
Purpose: one-step playground workflow.

- Prints title and instructions.
- Checks bnl_compiler.exe exists.
- Checks gcc exists in PATH.
- Reads pasted code lines until END.
  - Supports redirected input and interactive input.
- Joins lines into one C source string.
- Runs syntax detection:
  $code | .\bnl_compiler.exe
- If syntax invalid, stops.
- Creates temp folder under %TEMP%\bnl_compiler.
- Writes temp source file program.c.
- Compiles with gcc to program.exe.
- If compile fails, stops.
- If compile succeeds, runs program.exe.
- User can now provide runtime input values.


11) CODE EXPLANATION - run_bnl.bat
----------------------------------
- @echo off : cleaner command output.
- powershell -ExecutionPolicy Bypass -File "%~dp0run_bnl.ps1"
  Runs the PowerShell launcher from current script directory.


12) FULL EXAMPLE WORKFLOW
-------------------------
A) Build BNL compiler
- bison -d parser.y
- flex lexer.l
- gcc lex.yy.c parser.tab.c -o bnl_compiler.exe

B) Run playground
- .\run_bnl.bat

C) Paste this program:
#include <stdio.h>
int main() {
    int n;
    scanf("%d", &n);
    int arr[n];
    for(int i=0;i<n;i++) scanf("%d", &arr[i]);
    int max = arr[0];
    for(int i=1;i<n;i++) if(arr[i] > max) max = arr[i];
    printf("max=%d\n", max);
    return 0;
}
END

D) After compile, provide runtime input when asked, e.g.:
5
10 20 7 30 15


13) TROUBLESHOOTING
-------------------
Problem: 'bison' is not recognized
- Add Bison install folder to PATH
- Restart terminal

Problem: 'flex' is not recognized
- Add Flex install folder to PATH
- Restart terminal

Problem: 'gcc' is not recognized
- Install MinGW-w64 and add bin folder to PATH

Problem: parser.tab.h missing
- Run bison command first: bison -d parser.y

Problem: red underline in parser.y in editor
- If bison command succeeds, grammar is valid.
- Red highlight is often VS Code syntax support issue.

Problem: run_bnl.ps1 blocked by policy
- Use run_bnl.bat
or
- PowerShell as admin/user terminal:
  Set-ExecutionPolicy -Scope CurrentUser RemoteSigned


14) LIMITATIONS
---------------
- This is a prototype validator, not full C standard parser.
- Structural validation is lightweight text + token based.
- Some invalid C may still pass if structure appears valid.
- Final C correctness is guaranteed only by real GCC compilation step.


15) QUICK COMMAND CHEAT SHEET
-----------------------------
Build:
- bison -d parser.y
- flex lexer.l
- gcc lex.yy.c parser.tab.c -o bnl_compiler.exe

Detect only:
- .\bnl_compiler.exe

Detect from file:
- Get-Content .\input.c | .\bnl_compiler.exe

Detect + compile + run:
- .\run_bnl.bat


END OF FILE
