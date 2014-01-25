/*  Course: 1402CMSC4306380
	Project 1
	Author John M. Lasheski
	Date: Jan 25, 2014
	Platform: Flex, Cygwin64, Sublime Text 2


	tokens.h is part of a compiler project that compiles a simple functional language.
	
	tokens.h contains an enumeration of the variuos tokens defined by the functional
	language specification. It is included in the scanner.l file for assistance with
	the scanning process.
*/

enum Tokens {RELOP = 256, ADDOP = 257, MULOP = 258, IDENT = 259, BEGIN_ = 260,
 BOOLEAN = 261, ELSE = 262, END = 263, ENDIF = 264, FUNCTION = 265, IF = 266,
 IS = 267, INT = 268, REAL = 269, RETURNS = 270, THEN = 271, AND = 272,
 OR = 273, NOT = 274, BOOL_LIT = 275, INT_LIT = 276, REAL_LIT = 277};

 //INT, REAL, and BOOLEAN are for the reserved keywords
 //INT_LIT, REAL_LIT, and BOOL_LIT are for the data literals of each type
 