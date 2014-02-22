/*  Course: 1402CMSC4306380
	Project 3
	Author John M. Lasheski
	Date: Feb 21, 2014
	Platform: Flex, Cygwin64, Sublime Text 2
	
	locals.cpp is part of a compiler project that compiles a simple functional language.

	locals.cpp supplies the symbol table for identifier tokens found by parser.y
*/

#include <string>
#include <map>

using namespace std;

#include "locals.h"
#include "listing.h"

void Locals::insert(char* identifier, Types type)
{
	string name(identifier);

	// Check for Duplicate Name
	if(symbols.find(name) == symbols.end())
	{
		symbols[name] = type;
	
	} else {
		Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC,
		 "Attempting to create a duplicate identifier");
		
	}
}


Types Locals::lookUp(char* identifier)
{
	string name(identifier);
	map<string, Types>::iterator iterator;
	iterator = symbols.find(name);
	
	// Check for Undeclared  
	if(iterator == symbols.end())
	{
		Listing::GetInstance()->appendError(Listing::GetInstance()->SEMANTIC,
		 "Attempting to access an undeclared identifier");

		return UNKNOWN;
	}

	return iterator->second;
}

/* Called by the parser after completing a file so that the 
symbol table is empty when parsing the next file*/
void Locals::clear()
{
	symbols.clear();
}
