/*  Course: 1402CMSC4306380
	Project 3
	Author John M. Lasheski
	Date: Feb 21, 2014
	Platform: Flex, Cygwin64, Sublime Text 2


	scanner.l is part of a compiler project that compiles a simple functional language.
	
	scanner.l is called by parser.y and reads from the supplied input file to return tokens.
*/



%option noyywrap yylineno

%{
#include "listing.h"
#include "locals.h"
#include "tokens.h"
%}


ws		[ \t\r]+
line	[\n]
punc	[,:;\(\)]
relop	(<=|<|>=|>|\/=|=)
comment (--)[ a-zA-Z0-9,\.<>\\|`~\-_+=!@#$%^&*();:''""\[\]]*
ident	[A-Za-z](?:[a-zA-Z0-9]+)*
addop	[-+]
mulop	[*/]
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
{relop}		{ECHO; return RELOP;}
{bool}		{ECHO; yylval.types = BOOL_TYPE; return LITERAL;}
{addop}		{ECHO; return ADDOP;}
{mulop}		{ECHO; return MULOP;}
{real}		{ECHO; yylval.types = REAL_TYPE; return LITERAL;}
{int}		{ECHO; yylval.types = INT_TYPE; return LITERAL;}
{ident}		{ECHO; yylval.ident = (char*)malloc(yyleng + 1);
			strcpy(yylval.ident, yytext); return IDENT;}


.			{ECHO; Listing::GetInstance()->appendError(Listing::GetInstance()->LEXICAL, yytext);}

%%