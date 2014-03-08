

enum Types {UNKNOWN, INT_TYPE, REAL_TYPE, BOOL_TYPE,};


class Operand
{
public:
	Operand();
	Operand(char* op);


	Types getType();

	void print();

	bool getBoolValue();


	

	//I think we need an evalutae function for operand to return it's value. Nope.
	// The exrepssion calss should include a class called literal for storing and returning
	//the values. The operations need to be defined here though.

	
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