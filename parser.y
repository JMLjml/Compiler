/*  Course: 1402CMSC4306380
	Project 2
	Author John M. Lasheski
	Date: Feb 5, 2014
	Platform: Flex, Cygwin64, Sublime Text 2

*/

%{
// # include statments go here
#include <stdio.h>
//#include <stdlib.h>


int yylex(void);

void yyerror(const char *s)
{
	fprintf(stderr, "error: %s\n", s);
}

%}




//Declare Tokens
%token RELOP
%token ADDOP
%token MULOP
%token IDENT
%token BEGIN_
%token BOOLEAN
%token ELSE
%token END
%token ENDIF
%token FUNCTION
%token IF
%token IS
%token INT
%token REAL
%token RETURNS
%token THEN
%token AND
%token OR
%token NOT
%token BOOL_LIT
%token INT_LIT
%token REAL_LIT
//INT, REAL, and BOOLEAN are for the reserved keywords
//INT_LIT, REAL_LIT, and BOOL_LIT are for the data literals of each type




%%
function: {printf("printing from bison file parser.y\n");}

%%




int main(int argc, char **argv)
{
	printf("inside of main from parser.y\n");

	//yyparse();
	return 0;
}


