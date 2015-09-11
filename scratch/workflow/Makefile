CC=gcc
CFLAGS=-Wall -D_GNU_SOURCE

all: state dump workflow

clean:
	rm -f *.o action

errors.c.c: errors.c
	$(CC) -E $(CFLAGS) $< > $@

test:
	./errors ; ./errors 3 ; ./errors 2 ; ./errors 1 

action: action.c copy.c message.c

state: state.c copy.c

dump: dump.c

workflow: workflow.c
