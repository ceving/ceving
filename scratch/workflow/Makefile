CC=gcc
CFLAGS=-Wall

all: state dump workflow

clean:
	rm -f *.o action

test:
	./action

action: action.c copy.c message.c

state: state.c copy.c

dump: dump.c

workflow: workflow.c
