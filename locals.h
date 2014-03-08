/*  Course: 1402CMSC4306380
	Project 4
	Author John M. Lasheski
	Date: March 7, 2014
	Platform: Flex, Cygwin64, Sublime Text 2
	
	locals.h is part of a compiler project that compiles a simple functional language.

	locals.h supplies the symbol table for identifier tokens found by parser.y
*/

#include <string>
#include <map>
using namespace std;

enum Types {UNKNOWN, INT_TYPE, REAL_TYPE, BOOL_TYPE,};

class Locals
{
public:
	void insert(char* identifier, Types type);
	Types lookUp(char* identifier);
	void clear();
private:
	map<string, Types> symbols;
};