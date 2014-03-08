# Course: 1402CMSC4306380
#	Project 4
#	Author John M. Lasheski
#	Date: March 7, 2014
#	Platform: Flex, Cygwin64, Sublime Text 2

#	makefile for Project 3. Uses flex and g++ compilers.

compile: scanner.o parser.o listing.o locals.o operand.o
	g++ -Wall scanner.o parser.o listing.o locals.o operand.o -o compile 
	rm *.o

scanner.o: scanner.c listing.h tokens.h locals.h
	g++ -c -Wall -lfl scanner.c

scanner.c: scanner.l
	flex scanner.l
	mv lex.yy.c scanner.c

parser.o: parser.c locals.h listing.h operand.h
	g++ -c -Wall parser.c

parser.c tokens.h: parser.y
	bison -d -v -t parser.y
	mv parser.tab.c parser.c
	mv parser.tab.h tokens.h

listing.o: listing.cpp listing.h
	g++ -c -Wall listing.cpp

locals.o: locals.cpp locals.h
	g++ -c -Wall locals.cpp

operand.o: operand.cpp operand.h
	g++ -c -Wall operand.cpp

clean:
	rm scanner.c parser.c compile.exe parser.output tokens.h