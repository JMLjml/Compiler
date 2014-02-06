/*  Course: 1402CMSC4306380
	Project 1
	Author John M. Lasheski
	Date: Jan 25, 2014
	Platform: Flex, Cygwin64, Sublime Text 2


	scanner.l is part of a compiler project that compiles a simple functional language.
	
	scanner.l reads from the supplied input file and creates an output.txt file containing tokens and
	their lexical match. At this time scanner.l only recognizes Lexical errors.

	Usage from command line $ ./compile data.txt
*/



//this line should not be in the project 1 version...	

%option noyywrap yylineno

%{
#include "tokens.h"
#include "listing.h"
%}


ws		[ \t\r]+
line	[\n]
punc	[,:;\(\)]
relop	(<=|<|>=|>|\/=|=)
comment (--)[ a-zA-Z0-9]+
ident	[A-Za-z](?:[a-zA-Z0-9]+)*
addop	[-+]
mulop	[*/]
real	[0-9]+\.[0-9]+
int		[0-9]+
bool	(true|false)

%%

begin    	{ECHO; return BEGIN_;}
boolean		{ECHO; return BOOLEAN;}
else		{ECHO; return ELSE;}
function	{ECHO; return FUNCTION;}
is			{ECHO; return IS;}
integer		{ECHO; return INT;}
real		{ECHO; return REAL;}
returns		{ECHO; return RETURNS;}
then		{ECHO; return THEN;}
endif		{ECHO; return ENDIF;}
end			{ECHO; return END;}
if			{ECHO; return IF;}
and			{ECHO; return AND;}
or			{ECHO; return OR;}
not			{ECHO; return NOT;}

{line}		{ECHO; Listing::GetInstance()->nextLine();}
{ws}		{ECHO;}
{comment}	{ECHO;}
{punc}		{ECHO; return yytext[0];}
{relop}		{ECHO; return RELOP;}
{bool}		{ECHO; return BOOL_LIT;}
{addop}		{ECHO; return ADDOP;}
{mulop}		{ECHO; return MULOP;}
{real}		{ECHO; return REAL_LIT;}
{int}		{ECHO; return INT_LIT;}
{ident}		{ECHO; return IDENT;}


.			{ECHO; Listing::GetInstance()->appendError(Listing::GetInstance()->LEXICAL, yytext);}

%%

int main(int argc, char **argv)
{	

	//Invalid arguments
	if(argc < 2)
	{
		printf("Invalid input. Usage from command line $ ./compile data.txt\n");
		return 1;
	}

	//create and open an output.txt file for writing the token and lexeme pairs to
	FILE *fout = fopen("output.txt", "w");
	if(!fout)
	{
		printf("Error creating output file, exiting scanner.\n");
		return 1;
	}

	//For each file supplied, open and scan
	for(int i = 1; i < argc; i++)
	{
		FILE *f = fopen(argv[i], "r");

		//Invalid data file, exit scanning
		if(!f)
		{
			perror(argv[i]);
			return(1);
		}

		// set the line number to 1 each time we begin scanning a new file
		yylineno = 1;

		//for storing the token returned by yylex()
		int tok;

		//restart the scanner for scanning the new file
		yyrestart(f);
		
		//See if the input file actually has data to process, if so print the first line #
		char c = fgetc(f);
		if(c != EOF)
		{
			printf("%4d ", yylineno);
		}

		ungetc(c,f);//put the first char back to the file stream
		

		//While there are more lines of code to scan
		while((tok = yylex()))
		{
			//write the lexeme and token pairs to the output file			
			fprintf(fout, "%s %d\n", yytext, tok);
		}

		//close the input file
		fclose(f);
		
		//If we are done scanning, close the output file
		if(i == argc)
		{
			//close the output file
			fclose(fout);
		}

		//print the error summary at the end of scanning
		Listing::GetInstance()->printSummary();

		//destroy the Listing so we start with a clean slate for the next file
		Listing::GetInstance()->~Listing();
	}
	return 0;	
}