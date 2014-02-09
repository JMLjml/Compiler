/*  Course: 1402CMSC4306380
	Project 2
	Author John M. Lasheski
	Date: Feb 5, 2014
	Platform: Flex, Cygwin64, Sublime Text 2
	
	parser.y is part of a compiler project that compiles a simple functional language.

	parser.y parses the supplied input file and counts lexical and syntatical errors.

	Usage from command line $ ./compile data.txt


	Help for design of operator precedence from site:
	http://eli-project.sourceforge.net/elionline/syntax_1.html

*/

%{
#include <stdio.h>
#include "listing.h"

extern int yylex(void);
extern FILE *yyin;
extern int yylineno;
extern char *yytext;


void yyerror(const char *s)
{
	Listing::GetInstance()->appendError(Listing::GetInstance()->SYNTAX, s);
}


%}

%error-verbose


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
program:
	functionList;
	
functionList:
	functionList function_recovery body
	| function_recovery body;

function_recovery:   
    function ';' |
    error ';' ;

function:
	FUNCTION IDENT parameters RETURNS type
	| FUNCTION IDENT RETURNS type;

parameters:
	parameter ',' parameter
	| parameter;

parameter:
	IDENT ':' type;

type:
	INT | REAL | BOOLEAN;

body:
	variable BEGIN_ statement END ';'
	| BEGIN_ statement END ';'
	| error ';';

variable:
	variable IDENT ':' type IS statement
	| IDENT ':' type IS statement;

statement:
	expression ';'
	| IF expression THEN statement ELSE statement ENDIF ';';
	| error ';';

expression:
	expression OR and
	| and;

and:
	and AND relation
	| relation;

relation:
	relation RELOP sum
	| sum;

sum:
	sum ADDOP term
	| term;


term:
	term MULOP not
	| not;

not:
	NOT factor
	| factor;


factor:
	INT_LIT
	| REAL_LIT
	| BOOL_LIT
	| IDENT
	| IDENT '(' expression ')'
	| IDENT '(' expression ',' opt_exp ')'
	| '(' expression ')';

opt_exp:
	opt_exp ',' expression
	| expression;
	
%%




int main(int argc, char **argv)
{
	//Invalid arguments
	if(argc < 2)
	{
		printf("Invalid input. Usage from command line $ ./compile data.txt\n");
		return 1;
	}


	//For each file supplied, open and parse
	for(int i = 1; i < argc; i++)
	{
		FILE *f = fopen(argv[i], "r");

		//Invalid data file, exit scanning
		if(!f)
		{
			perror(argv[i]);
			return(1);
		}

		//Set yyin to the file to be parsed
		yyin = f;

		// set the line number to 1 each time we begin parsing a new file
		yylineno = 1;

		//See if the input file actually has data to process, if so print the first line #
		char c = fgetc(f);
		if(c != EOF)
		{
			printf("%4d ", yylineno);
		}

		ungetc(c,f);//put the first char back to the file stream
		
		//parse the file
		yyparse();

		//close the input file
		fclose(f);

		//print the error summary at the end of parsing
		Listing::GetInstance()->printSummary();

		//destroy the Listing so we start with a clean slate for the next file
		Listing::GetInstance()->~Listing();
	}	

	return 0;
}


