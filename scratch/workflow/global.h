#ifndef GLOBAL_H
#define GLOBAL_H

#include <stdio.h>
#include <errno.h>
#include <error.h>

#define ERROR(RETURN, FORMAT, ...) do {               \
    error_at_line (0, 0, __FILE__, __LINE__,          \
                   "ERROR: " FORMAT , ##__VA_ARGS__); \
    return -(RETURN);                                 \
  } while (0)

#define ERROR_N(RETURN, FORMAT, ...) do {             \
    int e = errno;                                    \
    error_at_line (0, e, __FILE__, __LINE__,          \
                   "ERROR: " FORMAT , ##__VA_ARGS__); \
    return -(RETURN);                                 \
  } while (0)

int copy (int source, int destination);

#endif /* GLOBAL_H */
