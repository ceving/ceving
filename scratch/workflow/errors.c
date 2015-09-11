#include <stdio.h>
#include <stdlib.h>
#include <syslog.h>
#include <string.h>
#include <errno.h>

#define SYSLOG(LEVEL, FORMAT, ARGS...)                              \
    syslog (LEVEL, FORMAT " [%s:%d]" , ##ARGS, __FILE__, __LINE__)

#define WARN(FORMAT, ARGS...)  SYSLOG(LOG_WARNING, FORMAT , ##ARGS)
#define INFO(FORMAT, ARGS...)  SYSLOG(LOG_INFO,    FORMAT , ##ARGS)
#define NOTE(FORMAT, ARGS...)  SYSLOG(LOG_NOTICE,  FORMAT , ##ARGS)
#define FAIL(FORMAT, ARGS...)  SYSLOG(LOG_ERR,     FORMAT , ##ARGS)
#define DEBUG(FORMAT, ARGS...) SYSLOG(LOG_DEBUG,   FORMAT , ##ARGS)

// IF with Type and format.
#define IF(EXPRESSION, CONDITION, CONTINUATION, TYPE, FORMAT)          \
    ({                                                                 \
        TYPE _VALUE = EXPRESSION;                                      \
        if (_VALUE CONDITION) {                                        \
            FAIL ("ERROR %s: %s => " FORMAT " %s.",                    \
                  #CONTINUATION,                                       \
                  #EXPRESSION,                                         \
                  _VALUE,                                              \
                  #CONDITION);                                         \
            goto CONTINUATION;                                         \
        }                                                              \
        _VALUE;                                                        \
    })

// Errno reporting IF with Format.
#define IFE(EXPRESSION, CONDITION, CONTINUATION, TYPE, FORMAT)         \
    ({                                                                 \
        int _ERRNUM = errno;                                           \
        TYPE _VALUE = EXPRESSION;                                      \
        if (_VALUE CONDITION) {                                        \
            FAIL (LOG_ERR,                                             \
                  "ERROR %s: %s => " FORMAT " %s. (%s)",               \
                  #CONTINUATION,                                       \
                  #EXPRESSION,                                         \
                  _VALUE,                                              \
                  #CONDITION,                                          \
                  strerror(_ERRNUM));                                  \
            goto CONTINUATION;                                         \
        }                                                              \
        _VALUE;                                                        \
    })

// IF with decimal format.
#define IFd(EXPRESSION, CONDITION, CONTINUATION)              \
    IF(EXPRESSION, CONDITION, CONTINUATION, typeof(EXPRESSION), "%d")

// IF with decial format and negative condition.
#define IFn(EXPRESSION, CONTINUATION)           \
    IFd(EXPRESSION, < 0, CONTINUATION)

// IF with string format.
#define IFs(EXPRESSION, CONDITION, CONTINUATION)              \
    IF(EXPRESSION, CONDITION, CONTINUATION, typeof(EXPRESSION), "%s")

// Errno reporting IF for integer expression.
#define IFEd(EXPRESSION, CONDITION, CONTINUATION)                       \
    IFE(EXPRESSION, CONDITION, CONTINUATION, typeof(EXPRESSION), "%d")

// Display the value of an expression.
#define TRACE(EXPRESSION, TYPE, FORMAT)                           \
    ({                                                            \
        TYPE _VALUE = EXPRESSION;                                 \
        DEBUG ("TRACE: %s => " FORMAT ".",                        \
               #EXPRESSION, _VALUE);                              \
        _VALUE;                                                   \
    })

#define TRACEd(EXPRESSION) TRACE(EXPRESSION, typeof(EXPRESSION), "%d")
#define TRACEs(EXPRESSION) TRACE(EXPRESSION, typeof(EXPRESSION), "%s")



int main (int argc, char *argv[])
{
    int result = 0;

    openlog ("errors", LOG_PERROR | LOG_CONS | LOG_PID | LOG_NDELAY, LOG_USER);

    IFs (argv[1], == NULL, MISSING_ARGUMENT);

    int a = atoi(argv[1]);

    TRACEd (a);

    IFn (printf ("x: %d\n", IFd(a, > 2, A_TOO_BIG)), PRINTF_FAILURE);
    IFn (printf ("y: %d\n", IFd(a+1, > 2, A_PLUS_ONE_TOO_BIG)), PRINTF_FAILURE);

    goto SUCCESS;

 PRINTF_FAILURE:
    result = result ? : 4;

 MISSING_ARGUMENT:
    result = result ? : 3;
                 
 A_TOO_BIG:
    result = result ? : 1;
    
 A_PLUS_ONE_TOO_BIG:
    result = result ? : 2;
    
 SUCCESS:
    closelog ();
    return result;
}
