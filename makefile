# Course: 1402CMSC4306380
#	Project 2
#	Author John M. Lasheski
#	Date: Feb 5, 2014
#	Platform: Flex, Cygwin64, Sublime Text 2

#	makefile for Project 1. Uses flex and g++ compilers.

compile: scanner.o parser.o listing.o
	g++ -Wall scanner.o parser.o listing.o -o compile 
	rm *.o

scanner.o: scanner.c listing.h tokens.h
	g++ -c -Wall -lfl scanner.c

scanner.c: scanner.l
	flex scanner.l
	mv lex.yy.c scanner.c

parser.o: parser.c listing.h
	g++ -c -Wall parser.c

parser.c tokens.h: parser.y
	bison -d -v parser.y
	mv parser.tab.c parser.c
	mv parser.tab.h tokens.h

listing.o: listing.cpp listing.h
	g++ -c -Wall listing.cpp

clean:
	rm scanner.c parser.c compile.exe parser.output