/*  Course: 1402CMSC4306380
	Project 4
	Author John M. Lasheski
	Date: March 7, 2014
	Platform: Flex, Cygwin64, Sublime Text 2
	
	operand.h is part of a compiler project that compiles a simple functional language.

	operand.h defines teh header file for the OPerand class. An Operand object is the base object used in construction
	of an expression tree. The Operand class serves as the leaf nodes for the tree.
*/

enum Types {UNKNOWN, INT_TYPE, REAL_TYPE, BOOL_TYPE,};


class Operand
{
public:
	Operand();
	Operand(char* op);
	Operand(int value);
	Operand(double value);
	Operand(bool value);

	Types getType();
	void print();
	bool getBoolValue();
		
	//Arithmetic operations
	friend Operand operator+(Operand left, Operand right);
	friend Operand operator-(Operand left, Operand right);
	friend Operand operator*(Operand left, Operand right);
	friend Operand operator/(Operand left, Operand right);

	//Relational operations
	friend Operand operator<(Operand left, Operand right);
	friend Operand operator<=(Operand left, Operand right);
	friend Operand operator>(Operand left, Operand right);
	friend Operand operator>=(Operand left, Operand right);
	friend Operand operator==(Operand left, Operand right);
	friend Operand operator!=(Operand left, Operand right);
	friend Operand operator!(Operand left);

	//Logic Operations
	friend Operand operator&&(Operand left, Operand right);
	friend Operand operator||(Operand left, Operand right);
	
private:
	Types type;
	union Value
	{
		int intValue;
		double realValue;
		bool boolValue;
	} value;

	void coerce();
	static Types Type_Check_Arithmetic(Operand& left, Operand& right);
	static Types Type_Check_Relop(Operand& left, Operand& right);
	static Types Type_Check_Logic(Operand& left, Operand& right);
};

typedef Operand* OperandPtr;