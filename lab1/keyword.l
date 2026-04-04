%{
  #include<stdio.h>

%}

%%
"int "      {printf ("Keyword int \n");}
"float"     {printf ("Keyword float \n");}
[0-9]+      {printf ( "Number \n );}
[a-zA-Z]+   {printf ("ALFABET\n");}
[ \t\n]     {}
.           {printf("unknown\n");}
%%
int yywrap(){
    return 1;

}
int main(){
    printf("THE EXpression inter ");
    yylex();
    return 0;
}