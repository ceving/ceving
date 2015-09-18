#ifndef ERRORS_HEADER
#define ERRORS_HEADER

#include <stdio.h>
#include <stdlib.h>
#include <syslog.h>
#include <string.h>
#include <errno.h>

#define SYSLOG(LEVEL, TAG, FORMAT, ARGS...)                              \
    syslog (LEVEL, TAG " " FORMAT " [%s:%d]" , ##ARGS, __FILE__, __LINE__)

#define WARN(FORMAT, ARGS...)  SYSLOG(LOG_WARNING, "WARNING", FORMAT , ##ARGS)
#define INFO(FORMAT, ARGS...)  SYSLOG(LOG_INFO,    "INFO",    FORMAT , ##ARGS)
#define NOTE(FORMAT, ARGS...)  SYSLOG(LOG_NOTICE,  "NOTICE",  FORMAT , ##ARGS)
#define FAIL(FORMAT, ARGS...)  SYSLOG(LOG_ERR,     "ERROR",   FORMAT , ##ARGS)
#define DEBUG(FORMAT, ARGS...) SYSLOG(LOG_DEBUG,   "DEBUG",   FORMAT , ##ARGS)

#define ERRORS(ARGS...) enum _RESULT { _SUCCESS , ##ARGS } _RESULT = _SUCCESS
#define RETURN() return _RESULT

#define ERRMSG(ERROR, FORMAT, ARGS...)               \
    FAIL ("%s/%s(%d): " FORMAT,               \
          __func__, #ERROR, ERROR , ##ARGS)
    
#define ERROR(ERROR, FORMAT, ARGS...) ({                \
    if (_RESULT == ERROR) {                             \
        ERRMSG (ERROR, FORMAT , ##ARGS);                \
    } })

#define IF1(EXPRESSION, CONDITION, CONTINUATION, FORMAT) ({ \
    typeof(EXPRESSION) _VALUE = EXPRESSION;                 \
    if (_VALUE CONDITION) {                                 \
        ERRMSG (CONTINUATION,                               \
                "%s => " FORMAT " %s.",                     \
                #EXPRESSION, _VALUE,                        \
                #CONDITION);                                \
        _RESULT = CONTINUATION;                             \
        goto CONTINUATION;                                  \
    }                                                       \
    _VALUE; })

#define IF2(EXPRESSION_1, OPERATOR, EXPRESSION_2, CONTINUATION, FORMAT) ({ \
    typeof(EXPRESSION_1) _VALUE_1 = EXPRESSION_1;                   \
    typeof(EXPRESSION_2) _VALUE_2 = EXPRESSION_2;                     \
    if (_VALUE_1 OPERATOR _VALUE_2) {                                 \
        ERRMSG (CONTINUATION,                                         \
                "%s => " FORMAT " %s %s => " FORMAT ".",              \
                #EXPRESSION_1, _VALUE_1,                              \
                #OPERATOR,                                            \
                #EXPRESSION_2, _VALUE_2);                             \
        _RESULT = CONTINUATION;                                     \
        goto CONTINUATION;                                          \
    }                                                               \
    _VALUE_1; })

#define IF_D(EXPRESSION_1, OPERATOR, EXPRESSION_2, CONTINUATION)        \
    IF2(EXPRESSION_1, OPERATOR, EXPRESSION_2, CONTINUATION, "%d")

#define IF_P(EXPRESSION_1, OPERATOR, EXPRESSION_2, CONTINUATION)        \
    IF2(EXPRESSION_1, OPERATOR, EXPRESSION_2, CONTINUATION, "%p")

#define IF_NULL(EXPRESSION, CONTINUATION)       \
    IF1(EXPRESSION, == NULL, CONTINUATION, "%p")

#define IF_NEG(EXPRESSION, CONTINUATION)        \
    IF1(EXPRESSION, < 0, CONTINUATION, "%d")

#define IF_NOT(EXPRESSION, CONTINUATION)        \
    IF1(EXPRESSION, != 0, CONTINUATION, "%d")

// Display the value of an expression.
#define TRACE(EXPRESSION, FORMAT)                                 \
    ({                                                            \
        typeof(EXPRESSION) _VALUE = EXPRESSION;                   \
        DEBUG ("%s => " FORMAT ".",                        \
               #EXPRESSION, _VALUE);                              \
        _VALUE;                                                   \
    })

#define TRACE_D(EXPRESSION) TRACE(EXPRESSION, "%d")

#endif // ERRORS_HEADER
