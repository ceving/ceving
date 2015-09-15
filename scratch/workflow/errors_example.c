#include "errors.h"

#include <stdarg.h>

// Standard functions need to be wrapped to conform to the convention
// to use the return value only for error reporting.

int xprintf (int *chars, const char *format, ...)
{
    ERRORS(PRINTF);

    int n;
    va_list ap;
    int errnum;

    va_start (ap, format);
    n = vprintf (format, ap);
    errnum = errno;
    va_end (ap);

    IF_NEG (n, PRINTF);

    if (chars != NULL)
        *chars = n;

 PRINTF:
    ERROR (PRINTF, "errno %d: %s", errnum, strerror(errnum));

    RETURN ();
}


int main (int argc, char *argv[])
{
    ERRORS (XPRINTF,
            MISSING_ARGUMENT,
            A_TOO_BIG,
            A_PLUS_ONE_TOO_BIG);

    openlog ("errors", LOG_PERROR | LOG_CONS | LOG_PID | LOG_NDELAY, LOG_USER);

    IF_NULL (argv[1], MISSING_ARGUMENT);

    int a = atoi(argv[1]);

    TRACE_D (a);

    IF_NOT (xprintf (NULL, "x: %d\n", IF_D (a, >, 2, A_TOO_BIG)), XPRINTF);
    IF_NOT (xprintf (NULL, "y: %d\n", IF_D (a+1, >, 2, A_PLUS_ONE_TOO_BIG)), XPRINTF);

 XPRINTF:
 MISSING_ARGUMENT:
 A_TOO_BIG:
 A_PLUS_ONE_TOO_BIG:
    
    closelog ();

    RETURN ();
}
