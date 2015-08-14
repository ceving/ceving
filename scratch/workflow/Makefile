CC=gcc
CFLAGS=-Wall
LEX=flex

all: data

clean:
	rm -f *.o *.tab.[cho] data

data: data.o parser.tab.o lexer.o message.o
	$(CC) $^ -lfl -o $@

%.tab.c %.tab.h: %.y
	bison -d $<
