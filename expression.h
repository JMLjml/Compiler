//#include "operand.h"
//#include "locals.h"

enum Operators {ADD, SUB, MUL, DIV, LT, LTOE, GT, GTOE, EE, NE};

class Expression
{
public:
	Expression(){}
	virtual Operand evaluate() = 0;
};

typedef Expression* ExprPtr;


class Literal: public Expression
{
public:
	Literal(Operand operand)
	{
		this->operand = operand;
	}

	Operand evaluate()
	{
		return operand;
	}

private:
	Operand operand;
};


class SubExpression : public Expression
{
public:
	SubExpression(ExprPtr left, ExprPtr right)
	{
		this->left = left;
		this->right = right;
	}

protected:
	ExprPtr left;
	ExprPtr right;
};



/*****************************************************************************************
*
*				ARITHMETIC OPERATIONS CLASSES
*
*****************************************************************************************/


class Plus: public SubExpression
{
public:
	Plus(ExprPtr left, ExprPtr right): SubExpression(left, right){}
	
	Operand evaluate()
	{
		return left->evaluate() + right->evaluate();
	}
};



class Minus: public SubExpression
{
public:
	Minus(ExprPtr left, ExprPtr right): SubExpression(left, right){}
	
	Operand evaluate()
	{
		return left->evaluate() - right->evaluate();
	}
};



class Multiply: public SubExpression
{
public:
	Multiply(ExprPtr left, ExprPtr right): SubExpression(left, right){}
	
	Operand evaluate()
	{
		return left->evaluate() * right->evaluate();
	}
};



class Divide: public SubExpression
{
public:
	Divide(ExprPtr left, ExprPtr right): SubExpression(left, right){}
	
	Operand evaluate()
	{
		return left->evaluate() / right->evaluate();
	}
};













/*****************************************************************************************
*
*				RELATIONAL OPERATIONS CLASSES
*
*****************************************************************************************/

class LessThan: public SubExpression
{
public:
    LessThan(Expression* left, Expression* right): SubExpression(left, right) {}
    
    Operand evaluate()
    {
		return left->evaluate() < right->evaluate();
    }
};


class LessThanOrEqual: public SubExpression
{
public:
    LessThanOrEqual(Expression* left, Expression* right): SubExpression(left, right) {}
    
    Operand evaluate()
    {
		return left->evaluate() <= right->evaluate();
    }
};


class GreaterThan: public SubExpression
{
public:
    GreaterThan(Expression* left, Expression* right): SubExpression(left, right) {}
    
    Operand evaluate()
    {
		return left->evaluate() > right->evaluate();
    }
};


class GreaterThanOrEqual: public SubExpression
{
public:
    GreaterThanOrEqual(Expression* left, Expression* right): SubExpression(left, right) {}
    
    Operand evaluate()
    {
		return left->evaluate() >= right->evaluate();
    }
};



class Equality: public SubExpression
{
public:
    Equality(Expression* left, Expression* right): SubExpression(left, right) {}
    
    Operand evaluate()
    {
		return left->evaluate() == right->evaluate();
    }
};



class NotEqual: public SubExpression
{
public:
    NotEqual(Expression* left, Expression* right): SubExpression(left, right) {}
    
    Operand evaluate()
    {
		return left->evaluate() != right->evaluate();
    }
};




/*****************************************************************************************
*
*				LOGICAL OPERATIONS CLASSES
*
*****************************************************************************************/


class And: public SubExpression
{
public:
    And(Expression* left, Expression* right): SubExpression(left, right) {}
    
    Operand evaluate()
    {
		return left->evaluate() && right->evaluate();
    }
};



class Or: public SubExpression
{
public:
    Or(Expression* left, Expression* right): SubExpression(left, right) {}
    
    Operand evaluate()
    {
		return left->evaluate() || right->evaluate();
    }
};






class Negation: public SubExpression
{
public:
    Negation(Expression* left, Expression* right): SubExpression(left, right) {}
    
    Operand evaluate()
    {
       return !(left->evaluate());
    }
};