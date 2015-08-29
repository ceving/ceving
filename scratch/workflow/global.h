#ifndef GLOBAL_H
#define GLOBAL_H

#include <stdio.h>
#include <errno.h>
#include <error.h>

extern char *program_invocation_name;

#define DEBUG(FORMAT, ...) do {                       \
    fprintf (stderr, "[%d] %s:%d: " FORMAT "\n",      \
             getpid(), __FILE__, __LINE__,            \
             ##__VA_ARGS__);                          \
  } while (0)

#define TRACE_INT(INT) do {                     \
    DEBUG("%s=%d", #INT, INT);                  \
  } while (0)


#define ERROR(RETURN, FORMAT, ...) do {               \
    error_at_line (0, 0, __FILE__, __LINE__,          \
                   "%d: ERROR: " FORMAT , getpid(),   \
                   ##__VA_ARGS__);                    \
    return -(RETURN);                                 \
  } while (0)

#define ERROR_N(RETURN, FORMAT, ...) do {             \
    int e = errno;                                    \
    error_at_line (0, e, __FILE__, __LINE__,          \
                   "%d: ERROR: " FORMAT ,             \
                   getpid(), ##__VA_ARGS__);          \
    return -(RETURN);                                 \
  } while (0)

int copy (int source, int destination);

#endif /* GLOBAL_H */
