#ifndef _LOGGING_H
#define _LOGGING_H

#include <syslog.h>
#include <string.h>

#ifndef FACILITY
#define FACILITY LOG_USER
#endif

#define SYSLOG(LEVEL, TAG, FORMAT, ARGS...)                              \
    syslog (LEVEL, TAG " " FORMAT " [%s:%d]" , ##ARGS, __FILE__, __LINE__)

#define WARN(FORMAT, ARGS...)  SYSLOG(LOG_WARNING, "WARN",  FORMAT , ##ARGS)
#define INFO(FORMAT, ARGS...)  SYSLOG(LOG_INFO,    "INFO",  FORMAT , ##ARGS)
#define NOTE(FORMAT, ARGS...)  SYSLOG(LOG_NOTICE,  "NOTE",  FORMAT , ##ARGS)

#define FAIL(RESULT, FORMAT, ARGS...)                                   \
  ({                                                                    \
    if (result.error) {                                                 \
      if (result.sys) {                                                 \
        SYSLOG(LOG_ERR, "ERROR %4X",                                    \
               FORMAT " SYSERR %d: %s.",                                \
               result.id , ##ARGS,                                      \
               result.error, strerror(result.error));                   \
      } else {                                                          \
        SYSLOG(LOG_ERR, "ERROR %4X",                                    \
               FORMAT " APPERR %d.",                                    \
               result.id , ##ARGS,                                      \
               result.error);                                           \
      }                                                                 \
    }                                                                   \
  })

#define DEBUG(FORMAT, ARGS...) SYSLOG(LOG_DEBUG,   "DEBUG", FORMAT , ##ARGS)

// Display the value of an expression.
#define TRACE(FORMAT, EXPRESSION)                                 \
  ({                                                              \
    typeof(EXPRESSION) _VALUE = EXPRESSION;                       \
    DEBUG ("%s => " FORMAT ".",                                   \
           #EXPRESSION, _VALUE);                                  \
    _VALUE;                                                       \
  })

#endif // _LOGGING_H
