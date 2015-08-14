#include <stdio.h>
#include <error.h>

#define TERMINATE 0

void syntax_error (const char *message)
{
  error (TERMINATE, 0, "%s", message);
}
