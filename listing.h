#include <string>
class Listing
{
private:
	Listing();
	static Listing* Instance;
	
	int lexCount;
	int synCount;
	int semCount;
	int lineCount;
	std::string errorMessage;

	public:
	static Listing* GetInstance();
	enum ErrorType {LEXICAL, SYNTAX, SEMANTIC};
	~Listing();
	void nextLine();
	void appendError(ErrorType error, char* message);
	void printSummary();	
};