enum Type {INTint, REALreal, BOOLbool};

class Operand
{
public:
	Operand();
	Operand(char* op);

	void print();


private:
	Type type;
	union Value
	{
		int intValue;
		double realValue;
		bool boolValue;
	} value;
};