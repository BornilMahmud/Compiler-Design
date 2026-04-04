%{
    #include<stdio.h>

%}

%%
[0-9]+      {printf ("NUMBER \n");}
[a-zA-Z]+   {printf ("ALFABET\n");}
.           { }
%%
int yywrap(){
    return 1;
}
int main(){
    printf ("ENTer the some ALFABET and NUMBER \n");
    yylex();
    return 0;
}