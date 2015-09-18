#include "errors.h"

#include <stdarg.h>

// Standard functions need to be wrapped to conform to the convention
// to use the return value only for error reporting.

#define ERRID(ERRNO) ((uint32_t)rand() << 16 | (uint32_t)(ERRNO) & 0xFFFF)

int xprintf (int *chars, const char *format, ...)
{
  ERRORS(printf);

  int n;
  va_list ap;
  int errnum;

  va_start (ap, format);
  n = vprintf (format, ap);
  errnum = errno;
  va_end (ap);

  IF_NEG (n, printf);

  if (chars != NULL)
    *chars = n;

printf:
  ERROR (printf, "errno %d: %s", errnum, strerror(errnum));

  RETURN ();
}


int main (int argc, char *argv[])
{
  ERRORS (print_failed,
          missing_argument,
          a_too_big,
          a_plus_one_too_big);

  openlog ("errors", LOG_PERROR | LOG_CONS | LOG_PID | LOG_NDELAY, LOG_USER);

  IF_NULL (argv[1], missing_argument);

  int a = atoi(argv[1]);

  TRACE_D (a);

  IF_NOT (xprintf (NULL, "x: %d\n", IF_D (a, >, 2, a_too_big)), print_failed);
  IF_NOT (xprintf (NULL, "y: %d\n", IF_D (a+1, >, 2, a_plus_one_too_big)), print_failed);

print_failed:
missing_argument:
a_too_big:
a_plus_one_too_big:
    
  closelog ();

  RETURN ();
}
