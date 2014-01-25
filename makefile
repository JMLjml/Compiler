# Course: 1402CMSC4306380
#	Project 1
#	Author John M. Lasheski
#	Date: Jan 25, 2014
#	Platform: Flex, Cygwin64, Sublime Text 2

#	makefile for Project 1. Uses flex and g++ compilers.

compile: scanner.o listing.o
	g++ -Wall scanner.o listing.o -o compile 
	rm *.o

scanner.o: scanner.c tokens.h
	g++ -c -Wall -lfl scanner.c

scanner.c: scanner.l
	flex scanner.l
	mv lex.yy.c scanner.c

listing.o: listing.cpp listing.h
	g++ -c -Wall listing.cpp

clean:
	rm scanner.c compile.exe