%option noyywrap yylineno
%{

#include "tokens.h"


%}





ws		[ \t\r]+
line	[\n]
punc	[,:;\(\)]
relop	(<=|<|>=|>)
comment (--)[ a-zA-Z0-9]+
ident	[A-Za-z](?:[a-zA-Z0-9]+)*



 


%%

{ws}		{ECHO;}
{comment}	{ECHO; printf(" found a comment");}
{line}		{ECHO; printf("Line %d\n", yylineno - 1);}
{punc}		{ECHO; return yytext[0];}
{relop}		{ECHO; return RELOP;}
{ident}		{ECHO; return IDENT;}


%%





int main(int argc, char **argv)
{	
	


	FILE *fout = fopen("output.txt", "w");
	if(!fout) {
		printf("Error creating output file, exiting scanner.\n");
		return 1;
	}

	//yyout = fout;



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

		while((tok = yylex())) {
			printf("The token and lexeme pair is: %d %s\n", tok, yytext);
			fprintf(fout, "%d %s\n", tok, yytext);

		}
		
		
		fclose(f);
		
	}
	return 0;	
}