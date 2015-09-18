                

#define IF(EXPRESSION, CONTINUATION) ({                                \
            if (EXPRESSION) {                                          \
                FAIL ("ERROR %s: %s.",                                 \
                      #CONTINUATION, #EXPRESSION);                     \
                _RESULT = CONTINUATION;                                \
                goto CONTINUATION;                                     \
            } })

#define IFF(EXPRESSION, CONTINUATION, FORMAT, ARGSs...) ({             \
            if (EXPRESSION) {                                          \
                FAIL ("ERROR %s: %s. " FORMAT,                         \
                      #CONTINUATION, #EXPRESSION , ARGS...);           \
                _RESULT = CONTINUATION;                                \
                goto CONTINUATION;                                     \
            } })

// IF with Type and format.
#define IF(EXPRESSION, CONDITION, CONTINUATION, FORMAT, ERRNO...)      \
    ({                                                                 \
        int _DEFAULT_ = 0;                                             \
        int _ERRNO = _DEFAULT_ 
        typeof(EXPRESSION) _VALUE = EXPRESSION;                        \
        if (_VALUE CONDITION) {                                        \
            FAIL ("ERROR %s: %s => " FORMAT " %s.",                    \
                  #CONTINUATION,                                       \
                  #EXPRESSION,                                         \
                  _VALUE,                                              \
                  #CONDITION);                                         \
            _RESULT = CONTINUATION;                                    \
            goto CONTINUATION;                                         \
        }                                                              \
        _VALUE;                                                        \
    })

// Errno reporting IF with Format.
#define IFE(EXPRESSION, CONDITION, CONTINUATION, FORMAT)               \
    ({                                                                 \
        int _ERRNO = errno;                                            \
        typeof(EXPRESSION) _VALUE = EXPRESSION;                        \
        if (_VALUE CONDITION) {                                        \
            FAIL (LOG_ERR,                                             \
                  "ERROR %s: %s => " FORMAT " %s. (%s)",               \
                  #CONTINUATION,                                       \
                  #EXPRESSION,                                         \
                  _VALUE,                                              \
                  #CONDITION,                                          \
                  strerror(_ERRNO));                                   \
            _RESULT = CONTINUATION;                                    \
            goto CONTINUATION;                                         \
        }                                                              \
        _VALUE;                                                        \
    })

// IF with decial format and negative condition.
#define IF_NEG(EXPRESSION, CONTINUATION)                  \
    IF(EXPRESSION, < 0, CONTINUATION, "%d")

// IF with pointer format and NULL condition.
#define IF_NULL(EXPRESSION, CONTINUATION)       \
    IF(EXPRESSION, == NULL, CONTINUATION, "%p")

// IF with decial format and negative condition.
#define IFE_NEG(EXPRESSION, CONTINUATION)      \
    IFE(EXPRESSION, < 0, CONTINUATION, "%d")

// IF with pointer format and NULL condition.
#define IFE_NULL(EXPRESSION, CONTINUATION)       \
    IFE(EXPRESSION, == NULL, CONTINUATION, "%p")
