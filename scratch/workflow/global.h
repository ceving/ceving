#ifndef GLOBAL_H
#define GLOBAL_H

#include <stdio.h>
#include <string.h>

#include "message.h"

#define STDERRMSG(PRIORITY, FORMAT, ...) do {           \
    static char buffer[0x1000];                         \
    if (log_message (buffer, sizeof(buffer),            \
                     PRIORITY, __FILE__, __LINE__,      \
                     FORMAT, ##__VA_ARGS__) > 0);       \
    fprintf (stderr, "%s\n", buffer);                   \
  } while (0)

#define TRACE(FORMAT, VALUE) do {                       \
    STDERRMSG(LOG_DEBUG, "%s=" FORMAT, #VALUE, VALUE);  \
  } while (0)

#define INFO(FORMAT, ...) do {                          \
    STDERRMSG(LOG_INFO, FORMAT, ##__VA_ARGS__);         \
  } while (0)

#define NOTICE(FORMAT, ...) do {                        \
    STDERRMSG(LOG_NOTICE, FORMAT, ##__VA_ARGS__);       \
  } while (0)

#define WARN(FORMAT, ...) do {                          \
    STDERRMSG(LOG_WARNING, FORMAT, ##__VA_ARGS__);      \
  } while (0)

#define ERROR(RETURN, FORMAT, ...) do {                 \
    STDERRMSG(LOG_ERR, FORMAT, ##__VA_ARGS__);          \
    return -(RETURN);                                   \
  } while (0)

#include <errno.h>

#define LERROR(RETURN, FORMAT, ...) do {                \
    int e = errno;                                      \
    ERROR(RETURN, FORMAT " (%s)",                       \
          ##__VA_ARGS__, strerror(e));                  \
  } while (0)

int copy (int source, int destination);

#endif /* GLOBAL_H */
