/*  Course: 1402CMSC4306380
	Project 4
	Author John M. Lasheski
	Date: March 7, 2014
	Platform: Flex, Cygwin64, Sublime Text 2


	scanner.l is part of a compiler project that compiles a simple functional language.
	
	scanner.l is called by parser.y and reads from the supplied input file to return tokens.
*/



%option noyywrap yylineno

%{
#include "locals.h"
#include "listing.h"
#include "expression.h"
#include "tokens.h"

%}


ws		[ \t\r]+
line	[\n]
punc	[,:;\(\)]
comment (--)[ a-zA-Z0-9,\.<>\\|`~\-_+=!@#$%^&*();:''""\[\]]*
ident	[A-Za-z](?:[a-zA-Z0-9]+)*
real	[0-9]+\.[0-9]*
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
"<="		{ECHO; yylval.name = LTOE; return RELOP;}
"<"			{ECHO; yylval.name = LT; return RELOP;}
">="		{ECHO; yylval.name = GTOE; return RELOP;}
">"			{ECHO; yylval.name = GT; return RELOP;}
"\/="		{ECHO; yylval.name = NE; return RELOP;}
"="			{ECHO; yylval.name = EE; return RELOP;}
{bool}		{ECHO; yylval.operand = new Operand(yytext); return LITERAL;}
"+"			{ECHO; yylval.name = ADD; return ADDOP;}
"-"			{ECHO; yylval.name = SUB; return ADDOP;}
"*"			{ECHO; yylval.name = MUL; return MULOP;}
"/"			{ECHO; yylval.name = DIV; return MULOP;}
{real}		{ECHO; yylval.operand = new Operand(yytext); return LITERAL;}
{int}		{ECHO; yylval.operand = new Operand(yytext); return LITERAL;}
{ident}		{ECHO; yylval.ident = (char*)malloc(yyleng + 1);
			strcpy(yylval.ident, yytext); return IDENT;}


.			{ECHO; Listing::GetInstance()->appendError(Listing::GetInstance()->LEXICAL, yytext);}

%%