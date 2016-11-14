/* Parser to convert "C" assignments to lisp. */
/* Compile: bison -d -y flexexample4.y */

%{
#if WITH_NO_C
#include "lex.yy.h"  /* Generated by reflex: scanner_t, yyscan_t, yylex_init, yylex_destroy */
#else
#include <stdio.h>
typedef void *yyscan_t;
int yylex(YYSTYPE*, yyscan_t);
void yylex_init(yyscan_t*);
void yylex_destroy(yyscan_t);
#endif
void yyerror(const char*);
/* Pass the parameter 'scanner' to yyparse through to yylex. */
#define YYPARSE_PARAM scanner
#define YYLEX_PARAM   scanner
%}

%pure-parser

%union {
    int num;
    char* str;
}

%token <str> STRING
%token <num> NUMBER

%%

assignments : assignment
            | assignment assignments
            ;
assignment  : STRING '=' NUMBER ';' { printf("(setf %s %d)\n", $1, $3); }
            ;

%%

int main()
{
#if WITH_NO_C
  yyscanner_t scanner;	// new way in C++ using reflex-generated yyscanner_t
  yyparse(&scanner);	// scanner is passed on to yylex()
#else
  yyscan_t scanner;	/* the old way in C */
  yylex_init(&scanner);
  yyparse(scanner);	/* scanner is passed on to yylex() */
  yylex_destroy(scanner);
#endif
}

void yyerror(const char *msg)
{
  fprintf(stderr, "%s\n", msg); /* how to use yylineno with bison-bridge? See flexexample5.y */
}
