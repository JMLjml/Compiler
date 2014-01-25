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
{bool}		{ECHO; return BOOL;}
{addop}		{ECHO; return ADDOP;}
{mulop}		{ECHO; return MULOP;}
{real}		{ECHO; return REAL;}
{int}		{ECHO; return INT;}
{ident}		{ECHO; return IDENT;}


.			{ECHO; Listing::GetInstance()->appendError(Listing::GetInstance()->LEXICAL, yytext);}

%%





int main(int argc, char **argv)
{	

	FILE *fout = fopen("output.txt", "w");
	if(!fout) {
		printf("Error creating output file, exiting scanner.\n");
		return 1;
	}

	
	if(argc < 2) { //just read from the stdin

		printf("Reading from the stdin.\n");
		yylex();
		return 0;
	}


	for(int i = 1; i < argc; i++) {
		FILE *f = fopen(argv[i], "r");

		if(!f) {
			perror(argv[i]);
			return(1);
		}

		yylineno = 1;

		int tok;

		yyrestart(f);

		printf("%4d ", yylineno);

		while((tok = yylex())) {
			//write the token and lexem pairs to the output file			
			fprintf(fout, "%d %s\n", tok, yytext);
		}
		
		//close the output file
		fclose(f);

		Listing::GetInstance()->printSummary();
		
	}
	return 0;	
}