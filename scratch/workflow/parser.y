%{
#include <stdio.h>
#include "message.h"
extern FILE *yyin;
int yylex (void);
void yyerror (char const *);
#define YYSTYPE char*
%}

%token EXACT
%token FLOAT
%token SYMBOL
%token STRING

%%

expr:           EXACT          { printf ("exact: '%s'\n", $1); }
        |       FLOAT          { printf ("float: '%s'\n", $1); }
        |       SYMBOL         { printf ("symbol: '%s'\n", $1); }
        |       STRING         { printf ("string: '%s'\n", $1); }
        |       '(' list ')'   { printf ("list\n"); }
        ;

list:           /* empty */    { }
        |       list expr      { }
        ;

%%

void yyerror (char const *s)
{
    syntax_error (s);
}

int main (int argc, char **argv)
{
    yyparse();
    return 0;
}
