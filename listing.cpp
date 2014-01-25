#include <stddef.h>
#include <stdio.h>
#include <string>
#include "Listing.h"

using namespace std;

/*Global Static Pointer set to NULL initially to 
denote that the singleton object has not yet been created*/
Listing* Listing::Instance = NULL;


Listing::Listing() {
	lexCount = 0;
	synCount = 0;
	semCount = 0;
	lineCount = 1;
	errorMessage.clear();
}

Listing::~Listing() {
	Instance = NULL;
	lexCount = 0;
	synCount = 0;
	semCount = 0;
	lineCount = 0;
	errorMessage.clear();
}

Listing* Listing::GetInstance() {
	if(!Instance) {
		Instance = new Listing();
	}
	return Instance;
}


void Listing::nextLine() {
	
	if(!errorMessage.empty()) {
		printf("%s", errorMessage.c_str());
		errorMessage.clear();
	}

	lineCount++;
	printf("%4d  ", lineCount);
}

void Listing::appendError(Listing::ErrorType error, char* message) {
	switch (error)
	{
	case Listing::LEXICAL:
		Listing::errorMessage.append("Lexical Error, Invalid Character ");
		Listing::errorMessage.append(message);
		Listing::errorMessage.append("\n");
		lexCount++;
		break;
	case Listing::SYNTAX:
		Listing::errorMessage.append("Syntax Error, ");
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

void Listing::printSummary() {
	printf("\n\nLexical Errors %d\n",Listing::lexCount);
	printf("Syntax Errors %d\n",Listing::synCount);
	printf("Semantic Errors %d\n",Listing::semCount);
}