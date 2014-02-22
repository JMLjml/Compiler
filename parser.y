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


#include <stdio.h>
#include "listing.h"
#include "locals.h"

extern int yylex(void);
extern FILE *yyin;
extern int yylineno;
extern char *yytext;



//functions for checking sematics
Types Type_Check_Same_Return(Types left, Types right);
Types Type_Check_Assignment(Types left, Types right);
Types Type_Check_Relop(Types left, Types right);
Types Type_Check_Logic(Types left, Types right);
Types Type_Check_Arithmetic(Types left, Types right);
Types Type_Check_Not(Types type);
void Type_Check_If(Types type);
void Type_Check_Same_If(Types left, Types right);


void yyerror(const char *s)
{
	Listing::GetInstance()->appendError(Listing::GetInstance()->SYNTAX, s);
}

//Symbol Table for the parser
Locals* locals = new Locals();

%}

%error-verbose

//Unionfor holding types
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


//Declare types for non terminals
%type <types> function_recovery
%type <types> function
%type <types> type
%type <types> body
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
	function_recovery body {Type_Check_Same_Return($1,$2);};

function_recovery:   
    function ';' |
    error ';' {$$ = UNKNOWN;};

function:
	FUNCTION IDENT parameters RETURNS type {locals->insert($2,$5); $$ = $5;}
	| FUNCTION IDENT RETURNS type {locals->insert($2,$4); $$ = $4;};

parameters:
	parameter ',' parameter
	| parameter;

parameter:
	IDENT ':' type {locals->insert($1,$3);};

type:
	INT {$$ = INT_TYPE;}
	| REAL {$$ = REAL_TYPE;}
	| BOOLEAN {$$ = BOOL_TYPE;};

body:
	variable BEGIN_ statement END ';' {$$ = $3;}
	| BEGIN_ statement END ';' {$$ = $2;}
	| error ';'{$$ = UNKNOWN;};

variable:
	variable IDENT ':' type IS statement {locals->insert($2,Type_Check_Assignment($4,$6));};
	| IDENT ':' type IS statement {locals->insert($1,Type_Check_Assignment($3,$5));};

statement:
	expression ';' 
	| IF expression {Type_Check_If($2);} THEN statement ELSE statement ENDIF ';'
	{Type_Check_Same_If($5, $7); $$ = $5;};
	| error ';'{$$ = UNKNOWN;};

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
	term MULOP not {$$ = Type_Check_Arithmetic($1, $3);}
	| not;

not:	
	NOT factor {$$ = Type_Check_Not($2);}
	| factor;


factor:
	LITERAL
	| IDENT {$$ = locals->lookUp($1);}
	| '(' expression ')'{$$ = $2;};


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

		//Clear out the symbol table so we start with a clean slate for the next file
		locals->clear();
	}	

	return 0;
}




/*****************************************************************************************
*
*				TYPE CHECKING FUNCTIONS
*
*****************************************************************************************/



/* A relational opperation should compare two Ints or two Reals. Booleans are not
allowed. If it is a valid comparrison the result should be a boolean type that is returned*/
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
		return BOOL_TYPE;
	}

	Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Attempting to use coercion during relational opperation.");

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



/* Checks to make sure that both opperands in an arithmetic expression
are of the same type, and that there is no coercion. Boolean opperators are not allowed.
Int opperators are allowed to widen to Reals*/
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


	//One of the opperands is an Int and the other is a Real - the return type will be widened to Real
	if((left == INT_TYPE || left == REAL_TYPE) && (right == INT_TYPE || right == REAL_TYPE))
	{
		return REAL_TYPE;
	}


	Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Attempting to use coercion during arithmetic opperation.");

	return UNKNOWN;
}



/* Checks to be sure that both opperands in a logic expression are of type boolean*/
Types Type_Check_Logic(Types left, Types right)
{
	if(left == BOOL_TYPE && right == BOOL_TYPE)
	{
		return left;
	}

	Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Attempting to use type other than boolean with logic opperation.");

	return UNKNOWN;
}



/* Checks to make sure the correct type of variable is being assigned to an identifier.
The compiler allows widening from type int durring assigment to real*/
Types Type_Check_Assignment(Types left, Types right)
{
	if(left == INT_TYPE && right == REAL_TYPE)
	{
		Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Attempting to assign Real to Int variable.");
	}

	if(left == INT_TYPE && right == BOOL_TYPE)
	{
		Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Attempting to assign Bool to Int variable.");
	}

	if(left == REAL_TYPE && right == BOOL_TYPE)
	{
		Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Attempting to assign Bool to Real variable.");
	}

	if(left == BOOL_TYPE && (right == INT_TYPE || right == REAL_TYPE))
	{
		Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Attempting to assign numeric value to Bool variable.");
	}

	return left;
}



/* Checks to make sure the expression evaluated in an IF statement returns type Boolean*/
void Type_Check_If(Types type)
{
	if(type != BOOL_TYPE)
	{
		Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Type Mismatch. Attempting to use if statment with type other than Bool_Type.");
	}
}



/* Checks that theepxressions in the Then portion and Else portion of an if statment
return the same type of value*/
void Type_Check_Same_If(Types left, Types right)
{
	if(left != right)
	{
		Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Then & Else statements are not of same return type.");
	}
}



/* Check the value returned by a function body. Int values are allowed to be widened to Real types. 
Wides cannot be coerced into Int return value. Suppresses returns of type UNKNOWN caused by errors
within the function body*/
Types Type_Check_Same_Return(Types left, Types right)
{
	if(left == right)
	{
		return left;
	}

	if(left == REAL_TYPE && right == INT_TYPE)
	{
		return left;
	}

	if(right == UNKNOWN)
	{
		return UNKNOWN;
	}

	Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC, 
		"Return Value does not match function header return type.");

	return UNKNOWN;
}