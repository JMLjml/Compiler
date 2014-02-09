/*  Course: 1402CMSC4306380
	Project 2
	Author John M. Lasheski
	Date: Feb 5, 2014
	Platform: Flex, Cygwin64, Sublime Text 2


	listing.h  is part of a compiler project that compiles a simple functional language.
	
	lisiting.h is the header file for the Singleton Listing class. 
	The Listing class is used by the scanner to print line numbers, count and display errors as they
	are encountered, and to summarize compilation status. It is a singleton object so the default
	contructor is private and can only be called by the GetInstance method. The Listing class is not
	thread safe.
*/

#include <string>
class Listing
{
private:
	Listing();
	static Listing* Instance;
	
	//integers for counting the number of each type of error encountered
	int lexCount;
	int synCount;
	int semCount;
	
	int lineCount;
	std::string errorMessage;

	public:
	~Listing();
	static Listing* GetInstance();
	enum ErrorType {LEXICAL, SYNTAX, SEMANTIC};
	void nextLine();
	void appendError(ErrorType error, const char* message);
	void printSummary();	
};