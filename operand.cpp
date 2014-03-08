#include <cstring>
#include <cstdlib>
//#include <iostream>
#include <string>
#include <algorithm>

#include <stdio.h>


using namespace std;

#include "operand.h"

//Operand::Operand(){}

Operand::Operand(char* op)
{
	
	//Type is Real
	if(strchr(op, '.'))
	{
		type = REALreal;
		value.realValue = atof(op);
	}


	//The type is a boolean
	else if((strchr(op, 't') || strchr(op, 'T') || strchr(op, 'f') || strchr(op, 'F')))
	{
		type = BOOLbool;

		string str = string(op);

		std::transform(str.begin(), str.end(), str.begin(), ::tolower);

		if(str == "false")
		{
			value.boolValue = false;
		}

		else if(str == "true")
		{
			value.boolValue = true;
		} 

		else
		{
			printf("Invalid parameter: %s.\n",op);
		}
	
	} 

	//the type must be int
	else {
		type = INTint;
		value.intValue = atoi(op);
	}	
}

void Operand::print()
{
	

	switch(type)
	{

		case INTint:
			printf("The type is INT and the value is %d\n", value.intValue);
			break;

		case REALreal:
			printf("The type is REAL and the value is %f\n", value.realValue);
			break;

		case BOOLbool:
			printf("The type is bool and the value is");
			printf("%s", value.boolValue ? " true.\n" : " false.\n");
			break;

		default:
			break;
	}
	
}