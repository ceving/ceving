#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main (int argc, char **argv)
{
	int8_t a, b, c;

	a = atoi (argv[1]);
	b = atoi (argv[2]);

	printf ("%d\n", a);
	printf ("%d\n", b);

	c = a + b;

	printf ("%d\n", c);

	return 0;
}
