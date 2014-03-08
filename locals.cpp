/*  Course: 1402CMSC4306380
	Project 4
	Author John M. Lasheski
	Date: March 7, 2014
	Platform: Flex, Cygwin64, Sublime Text 2
	
	locals.cpp is part of a compiler project that compiles a simple functional language.

	locals.cpp supplies the symbol table for identifier tokens found by parser.y
*/

#include <string>
#include <map>

using namespace std;

#include "locals.h"
#include "listing.h"

void Locals::insert(char* identifier, Operand op)
{
	string name(identifier);

	// Check for Duplicate Name
	if(symbols.find(name) == symbols.end())
	{
		symbols[name] = op;
	
	} else {
		Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC,
		 "Attempting to create a duplicate identifier");
		
	}
}


Operand* Locals::lookUp(char* identifier)
{
	string name(identifier);
	map<string, Operand>::iterator iterator;
	iterator = symbols.find(name);
	
	// Check for Undeclared  
	if(iterator == symbols.end())
	{
		Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC,
		 "Attempting to access an undeclared identifier");

		return new Operand();
	}

	return &iterator->second;
}

/* Called by the parser after completing a file so that the 
symbol table is empty when parsing the next file*/
void Locals::clear()
{
	symbols.clear();
}
