/*  Course: 1402CMSC4306380
	Project 2
	Author John M. Lasheski
	Date: Feb 5, 2014
	Platform: Flex, Cygwin64, Sublime Text 2


	listing.cpp  is part of a compiler project that compiles a simple functional language.
	
	lisiting.cpp is the source file for the Singleton Listing class. 
	The Listing class is used by the scanner to print line numbers, count and display errors as they
	are encountered, and to summarize compilation status. It is a singleton object so the default
	contructor is private and can only be called by the GetInstance method. The Listing class is not
	thread safe.
*/

#include <stddef.h>
#include <stdio.h>
#include <string>
#include "Listing.h"

using namespace std;

/*Global Static Pointer set to NULL initially to 
denote that the singleton object has not yet been created*/
Listing* Listing::Instance = NULL;


Listing::Listing()
{
	lexCount = 0;
	synCount = 0;
	semCount = 0;
	lineCount = 1;//if we get here, there is at least one line of code
	errorMessage.clear();
}

Listing::~Listing()
{
	Instance = NULL;
	lexCount = 0;
	synCount = 0;
	semCount = 0;
	lineCount = 0;
	errorMessage.clear();
}

//returns the current instance of Listing class if it exists, or a new instance if not
Listing* Listing::GetInstance()
{
	if(!Instance) {
		Instance = new Listing();
	}
	return Instance;
}


//print any error messages and the next line number
void Listing::nextLine()
{
	if(!errorMessage.empty()) {
		printf("%s", errorMessage.c_str());
		errorMessage.clear();
	}

	lineCount++;
	printf("%4d ", lineCount);
}


//append the correct error message onto the errormessage string for later priting
void Listing::appendError(Listing::ErrorType error, const char* message)
{
	switch (error)
	{
	case Listing::LEXICAL:
		Listing::errorMessage.append("Lexical Error, Invalid Character ");
		Listing::errorMessage.append(message);
		Listing::errorMessage.append("\n");
		lexCount++;
		break;
	case Listing::SYNTAX:
		Listing::errorMessage.append(message);
		Listing::errorMessage.append("\n");
		synCount++;
		break;
	case Listing::SEMANTIC:
		Listing::errorMessage.append("Semantic Error, ");
		Listing::errorMessage.append(message);
		Listing::errorMessage.append("\n");
		semCount++;
		break;
	default:
		Listing::errorMessage.append("Unknown Error, ");
		Listing::errorMessage.append(message);
		Listing::errorMessage.append("\n");
		break;
	}
}

//Prints the total number of errors encountered
void Listing::printSummary()
{
	//print the last set of error messages before printing the summary
	if(!errorMessage.empty()) {
		printf("\n%s", errorMessage.c_str());
		errorMessage.clear();
	}
	
	//print the correct summary messages
	if(Listing::lexCount == 0 && Listing::synCount == 0 && Listing::semCount == 0)
	{
		printf("\n\n Compiled Sucessfully\n\n");
	} else
	{	
	printf("\n\nLexical Errors %d\n",Listing::lexCount);
	printf("Syntax Errors %d\n",Listing::synCount);
	printf("Semantic Errors %d\n\n",Listing::semCount);
	}	
}