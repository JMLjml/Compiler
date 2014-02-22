/*  Course: 1402CMSC4306380
	Project 3
	Author John M. Lasheski
	Date: Feb 21, 2014
	Platform: Flex, Cygwin64, Sublime Text 2
	
	parser.y is part of a compiler project that compiles a simple functional language.

	parser.y parses the supplied input file and counts lexical and syntatical errors.

	Usage from command line $ ./compile data.txt


	Help for design of operator precedence from site:
	http://eli-project.sourceforge.net/elionline/syntax_1.html

*/

%{

#define YYDEBUG 1

#include <stdio.h>
#include "listing.h"
#include "locals.h"

extern int yylex(void);
extern FILE *yyin;
extern int yylineno;
extern char *yytext;



//functions for checking indiv sematics
Types Type_Check_Assignment(Types left, Types right);
Types Type_Check_Relop(Types left, Types right);
Types Type_Check_Logic(Types left, Types right);
Types Type_Check_Arithmetic(Types left, Types right);
Types Type_Check_Not(Types type);

Types checkTypes(Types left, Types right);









void yyerror(const char *s)
{
	Listing::GetInstance()->appendError(Listing::GetInstance()->SYNTAX, s);
}

//Symbol Table for the parser
Locals* locals = new Locals();

%}

%error-verbose


%union
{
	char* ident;
	Types types;
}


//Declare Tokens
%token RELOP
%token ADDOP
%token MULOP
%token BEGIN_
%token ELSE
%token END
%token ENDIF
%token FUNCTION
%token IF
%token IS
%token RETURNS
%token THEN
%token AND
%token OR
%token NOT
%token <ident> IDENT
%token <types> INT
%token <types> REAL
%token <types> BOOLEAN
%token <types> LITERAL
//INT, REAL, and BOOLEAN are for the reserved keywords








%type <types> type
//%type <types> body
%type <types> variable
%type <types> statement
%type <types> expression
%type <types> and
%type <types> relation
%type <types> sum
%type <types> term
%type <types> not
%type <types> factor



%%
program:
	function;
	
function:
	function_recovery body;

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
	INT {$$ = INT_TYPE;}
	| REAL {$$ = REAL_TYPE;}
	| BOOLEAN {$$ = BOOL_TYPE;};

body:
	variable BEGIN_ statement END ';'
	| BEGIN_ statement END ';'
	| error ';';

variable:
	variable IDENT ':' type IS statement {locals->insert($2,Type_Check_Assignment($4,$6));};
	| IDENT ':' type IS statement {locals->insert($1,Type_Check_Assignment($3,$5));};

statement:
	expression ';' {$$ = $1;}
	| IF expression THEN statement ELSE statement ENDIF ';';
	| error ';';

expression:
	expression OR and {$$ = Type_Check_Logic($1, $3);}
	| and;


and:
	and AND relation {$$ = Type_Check_Logic($1, $3);}
	| relation;



relation:
	relation RELOP sum {$$ = Type_Check_Relop($1, $3);}
	| sum;

sum:
	sum ADDOP term {$$ = Type_Check_Arithmetic($1, $3);}
	| term;


term:
	term MULOP not //{$$ = Type_Check_Arithmetic($1, $3);} -- this one might not be needed
	| not;

not:
	NOT factor {$$ = Type_Check_Not($2);}
	| factor;


factor:
	LITERAL {$$ = $1;}
	| IDENT {$$ = locals->lookUp($1);}
	| '(' expression ')'{ $$ = $2;};

%%




Types Type_Check_Relop(Types left, Types right)
{
	if(left == BOOL_TYPE || right == BOOL_TYPE)
	{
		Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Attempting to use Bool_Type with relational opperation.");

		return UNKNOWN;		
	}


	if(left == right)
	{
		return left;
	}


	Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Attempting to use coercion during relational opperation.");

	return UNKNOWN;


}


Types Type_Check_Assignment(Types left, Types right)
{
	if(left == right)
	{
		return left;
	}

	Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Attempting assigment with two different types.");

	return UNKNOWN;
}

Types Type_Check_Logic(Types left, Types right)
{
	if(left == BOOL_TYPE && right == BOOL_TYPE)
	{
		return left;
	}

	Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Attempting to use Literal with logic opperation.");

	return UNKNOWN;
}




Types Type_Check_Arithmetic(Types left, Types right)
{
	
	if(left == BOOL_TYPE || right == BOOL_TYPE)
	{
		Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Attempting to use Bool_Type with arithmetic opperation.");

		return UNKNOWN;		
	}

	if(left == right)
	{
		return left;
	}


	Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Attempting to use coercion during arithmetic opperation.");

	return UNKNOWN;

}


/*Checks to make sure a boolean operator is being used with the not statement*/
Types Type_Check_Not(Types type)
{
	if(type != BOOL_TYPE)
	{
		Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Attempting to use unexpected type with 'not' opperation. Type should be boolean.");

		return UNKNOWN;
	}

	return type;
}





Types checkTypes(Types left, Types right)
{
	if(left == right)
	{
		return left;
	}

	switch(left)
	{
	
	//The types dont match as they should, print an error message
	case INT_TYPE:
		if(right == REAL_TYPE)
		{
			Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Expected Int, received Real.");
		} else {
			Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Expected Int, received Boolean");
		}
		break;
	
	case REAL_TYPE:
		if(right == INT_TYPE)
		{
			Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Expected Real, received Int.");
		} else {
			Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Expected Real, received Boolean");
		}
		break;

	case BOOL_TYPE:
		if(right == INT_TYPE)
		{
			Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Expected Boolean, received Int.");
		} else {
			Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Expected Boolean, received Real");
		}
		break;
	}	

	return UNKNOWN;
}



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

		//Clear out the symbol table so we start with a clean slate for the next file
		locals->clear();
	}	

	return 0;
}


