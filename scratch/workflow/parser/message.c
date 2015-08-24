#include <stdio.h>
#include <error.h>

#define TERMINATE 0

void syntax_error (const char *message)
{
  error (TERMINATE, 0, "Syntax error: %s", message);
}

void memory_error (const char *message)
{
  error (TERMINATE, 0, "Memory error: %s", message);
}
