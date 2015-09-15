CC = gcc
override CFLAGS += -Wall -D_GNU_SOURCE

all: state dump workflow

clean:
	rm -f *.o action errors_example

errors.c.c: errors.c
	$(CC) -E $(CFLAGS) $< > $@

test: errors_example
	./errors_example ; ./errors_example 3 ; ./errors_example 2 ; ./errors_example 1 

action: action.c copy.c message.c

state: state.c copy.c

dump: dump.c

workflow: workflow.c
