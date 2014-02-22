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