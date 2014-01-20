compile: scanner.o
	g++ -Wall scanner.o -o compile 
	rm *.o

scanner.o: scanner.c
	g++ -c -Wall -lfl scanner.c

scanner.c: scanner.l
	flex scanner.l
	mv lex.yy.c scanner.c

clean:
	rm scanner.c compile.exe