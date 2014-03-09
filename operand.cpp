/*  Course: 1402CMSC4306380
	Project 4
	Author John M. Lasheski
	Date: March 7, 2014
	Platform: Flex, Cygwin64, Sublime Text 2
	
	operand.h is part of a compiler project that compiles a simple functional language.

	operand.h defines teh header file for the OPerand class. An Operand object is the base object used in construction
	of an expression tree. The Operand class serves as the leaf nodes for the tree.
*/

#include <cstring>
#include <cstdlib>
#include <string>
#include <algorithm>
#include <stdio.h>

using namespace std;

#include "operand.h"


/*Default constructor sets the type to unkown and the realValue to 0.*/
Operand::Operand()
{
	type = UNKNOWN;
	value.realValue = 0.0;
}


Operand::Operand(char* op)
{
	
	//Type is Real
	if(strchr(op, '.'))
	{
		type = REAL_TYPE;
		value.realValue = atof(op);
	}


	//The type is a boolean
	else if((strchr(op, 't') || strchr(op, 'T') || strchr(op, 'f') || strchr(op, 'F')))
	{
		string str = string(op);
		std::transform(str.begin(), str.end(), str.begin(), ::tolower);

		if(str == "false")
		{
			type = BOOL_TYPE;
			value.boolValue = false;
		}

		else if(str == "true")
		{
			type = BOOL_TYPE;
			value.boolValue = true;
		} 

		else
		{
			type = UNKNOWN;
			printf("Invalid parameter: %s.\n",op);
		}	
	} 

	//the type must be int
	else {
		type = INT_TYPE;
		value.intValue = atoi(op);
	}	
}


/* Constructors for specifying Operand Type only. Value is a dummy value*/
Operand::Operand(int value)
{
	type = INT_TYPE;
	this->value.intValue = value;
}

Operand::Operand(double value)
{
	type = REAL_TYPE;
	this->value.realValue = value;
}

Operand::Operand(bool value)
{
	type = BOOL_TYPE;
	this->value.boolValue = value;
}


/*Returns the type of the current Operand*/
Types Operand::getType()
{
	return type;
}

/*Useful for error checking during expression evaluation*/
bool Operand::getBoolValue()
{
	return value.boolValue;
}


/*Print the type and data of an Operand. Called by the parser after the expression tree has been evaluated.*/
void Operand::print()
{
	switch(type)
	{
		case INT_TYPE:
			printf(" The result is of type Integer and the value is %d.\n", value.intValue);
			break;

		case REAL_TYPE:
			printf(" The result is of type Real and the value is %f.\n", value.realValue);
			break;

		case BOOL_TYPE:
			printf(" The result is of type Boolean and the value is");
			printf("%s", value.boolValue ? " true.\n" : " false.\n");
			break;

		default:
			break;
	}
}



/*****************************************************************************************
*
*				ARITHMETIC OPERATIONS
*
*****************************************************************************************/

Operand operator+(Operand left, Operand right)
{
	Operand result;

	result.type = Operand::Type_Check_Arithmetic(left, right);

	//This in an error bools should not be added. return an UNKNOWN type
	if(result.type == BOOL_TYPE)
	{
		result.type = UNKNOWN;
		result.value.realValue = 0.0;
		return result;
	}

	if(result.type == INT_TYPE)
	{
		result.value.intValue = left.value.intValue + right.value.intValue;
	}

	else
	{
		result.value.realValue = left.value.realValue + right.value.realValue;
	}

	return result;
}



Operand operator-(Operand left, Operand right)
{
	Operand result;

	result.type = Operand::Type_Check_Arithmetic(left, right);

	//This in an error bools should not be subtracted. return an UNKNOWN type
	if(result.type == BOOL_TYPE)
	{
		result.type = UNKNOWN;
		result.value.realValue = 0.0;
		return result;
	}

	if(result.type == INT_TYPE)
	{
		result.value.intValue = left.value.intValue - right.value.intValue;
	}

	else
	{
		result.value.realValue = left.value.realValue - right.value.realValue;
	}

	return result;
}



Operand operator*(Operand left, Operand right)
{
	Operand result;

	result.type = Operand::Type_Check_Arithmetic(left, right);

	//This in an error bools should not be multiplied. return an UNKNOWN type
	if(result.type == BOOL_TYPE)
	{
		result.type = UNKNOWN;
		result.value.realValue = 0.0;
		return result;
	}

	if(result.type == INT_TYPE)
	{
		result.value.intValue = left.value.intValue * right.value.intValue;
	}

	else
	{
		result.value.realValue = left.value.realValue * right.value.realValue;
	}

	return result;
}



Operand operator/(Operand left, Operand right)
{
	Operand result;

	result.type = Operand::Type_Check_Arithmetic(left, right);

	//This in an error bools should not be divided. return an UNKNOWN type
	if(result.type == BOOL_TYPE)
	{
		result.type = UNKNOWN;
		result.value.realValue = 0.0;
		return result;
	}

	if(result.type == INT_TYPE)
	{
		result.value.intValue = left.value.intValue / right.value.intValue;
	}

	else
	{
		result.value.realValue = left.value.realValue / right.value.realValue;
	}

	return result;
}





/*****************************************************************************************
*
*				RELATIONAL OPERATIONS
*
*****************************************************************************************/

Operand operator<(Operand left, Operand right)
{
	Types type = Operand::Type_Check_Relop(left,right);

	//The supplied arguments are not of the right type
	if(type != BOOL_TYPE)
	{
		return Operand();
	}	

	Operand result = Operand();
	result.type = BOOL_TYPE;
	
	if(left.type == INT_TYPE)
	{		
		result.value.boolValue = left.value.intValue < right.value.intValue ? true : false;
	}
	else
	{
		result.value.boolValue = left.value.realValue < right.value.realValue ? true : false;
	}

	return result;
}



Operand operator<=(Operand left, Operand right)
{
	Types type = Operand::Type_Check_Relop(left,right);

	//The supplied arguments are not of the right type
	if(type != BOOL_TYPE)
	{
		return Operand();
	}	

	Operand result = Operand();
	result.type = BOOL_TYPE;
	
	if(left.type == INT_TYPE)
	{		
		result.value.boolValue = left.value.intValue <= right.value.intValue ? true : false;
	}
	else
	{
		result.value.boolValue = left.value.realValue <= right.value.realValue ? true : false;
	}

	return result;
}



Operand operator>(Operand left, Operand right)
{
	Types type = Operand::Type_Check_Relop(left,right);

	//The supplied arguments are not of the right type
	if(type != BOOL_TYPE)
	{
		return Operand();
	}	

	Operand result = Operand();
	result.type = BOOL_TYPE;
	
	if(left.type == INT_TYPE)
	{		
		result.value.boolValue = left.value.intValue > right.value.intValue ? true : false;
	}
	else
	{
		result.value.boolValue = left.value.realValue > right.value.realValue ? true : false;
	}

	return result;
}



Operand operator>=(Operand left, Operand right)
{
	Types type = Operand::Type_Check_Relop(left,right);

	//The supplied arguments are not of the right type
	if(type != BOOL_TYPE)
	{
		return Operand();
	}	

	Operand result = Operand();
	result.type = BOOL_TYPE;
	
	if(left.type == INT_TYPE)
	{		
		result.value.boolValue = left.value.intValue >= right.value.intValue ? true : false;
	}
	else
	{
		result.value.boolValue = left.value.realValue >= right.value.realValue ? true : false;
	}

	return result;
}



Operand operator==(Operand left, Operand right)
{
	Types type = Operand::Type_Check_Relop(left,right);

	//The supplied arguments are not of the right type
	if(type != BOOL_TYPE)
	{
		return Operand();
	}	

	Operand result = Operand();
	result.type = BOOL_TYPE;
	
	if(left.type == INT_TYPE)
	{		
		result.value.boolValue = left.value.intValue == right.value.intValue ? true : false;
	}
	else
	{
		result.value.boolValue = left.value.realValue == right.value.realValue ? true : false;
	}

	return result;
}



Operand operator!=(Operand left, Operand right)
{
	Types type = Operand::Type_Check_Relop(left,right);

	//The supplied arguments are not of the right type
	if(type != BOOL_TYPE)
	{
		return Operand();
	}	

	Operand result = Operand();
	result.type = BOOL_TYPE;
	
	if(left.type == INT_TYPE)
	{		
		result.value.boolValue = left.value.intValue != right.value.intValue ? true : false;
	}
	else
	{
		result.value.boolValue = left.value.realValue != right.value.realValue ? true : false;
	}

	return result;
}


/*****************************************************************************************
*
*				LOGICAL OPERATIONS
*
*****************************************************************************************/

Operand operator!(Operand left)
{
	if(left.type != BOOL_TYPE)
	{
		return Operand();
	}

	else
	{
		Operand result = Operand();
		result.type = BOOL_TYPE;
		result.value.boolValue = !left.value.boolValue;
		return result;
	}
}




Operand operator&&(Operand left, Operand right)
{
	Types type = Operand::Type_Check_Logic(left,right);

	//The supplied arguments are not of the right type
	if(type != BOOL_TYPE)
	{
		return Operand();
	}	

	Operand result = Operand();
	result.type = BOOL_TYPE;
	
	result.value.boolValue = left.value.boolValue && right.value.boolValue;

	return result;
}



Operand operator||(Operand left, Operand right)
{
	Types type = Operand::Type_Check_Logic(left,right);

	//The supplied arguments are not of the right type
	if(type != BOOL_TYPE)
	{
		return Operand();
	}	

	Operand result = Operand();
	result.type = BOOL_TYPE;
	
	result.value.boolValue = left.value.boolValue || right.value.boolValue;
	
	return result;
}






/*****************************************************************************************
*
*				TYPE CHECKING FUNCTIONS
*
*****************************************************************************************/


/* Checks to make sure that both opperands in an arithmetic expression
are of the same type, and that there is no coercion. Boolean opperators are not allowed.
Int opperators are allowed to widened to Reals*/
Types Operand::Type_Check_Arithmetic(Operand& left, Operand& right)
{
	if(left.type == BOOL_TYPE || right.type == BOOL_TYPE)
	{
		return UNKNOWN;		
	}

	
	if(left.type == UNKNOWN || right.type == UNKNOWN)
	{
		return UNKNOWN;
	}


	if(left.type == right.type)
	{
		return left.type;
	}


	/*One of the opperands is an Int and the other is a Real - the return type will be widened to Real and the
	operand will be converted to real also*/
	if(left.type == INT_TYPE)
	{
		left.coerce();
	}
	else
	{
		right.coerce();
	}

	return REAL_TYPE;
}



/* A relational opperation should compare two Ints or two Reals. Booleans are not
allowed. If it is a valid comparrison the result should be a boolean type that is returned*/
Types Operand::Type_Check_Relop(Operand& left, Operand& right)
{
	if(left.type == BOOL_TYPE || right.type == BOOL_TYPE)
	{
		return UNKNOWN;		
	}

	if(left.type == right.type)
	{
		return BOOL_TYPE;
	}

	return UNKNOWN;
}



/* Checks to be sure that both opperands in a logic expression are of type boolean*/
Types Operand::Type_Check_Logic(Operand& left, Operand& right)
{
	if(left.type == BOOL_TYPE && right.type == BOOL_TYPE)
	{
		return left.type;
	}

	return UNKNOWN;
}



/*Helper method that widens the supplied operand to a REAL_TYPE*/
void Operand::coerce()
{
	type = REAL_TYPE;
	value.realValue = value.intValue;
}