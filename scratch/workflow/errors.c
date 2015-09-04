#include <stdio.h>
#include <stdlib.h>

#define IF(EXPRESSION, CONDITION, CONTINUATION, ...)                    \
    ({                                                                  \
        typeof(EXPRESSION) _RESULT = EXPRESSION;                        \
        if (_RESULT CONDITION) {                                        \
            fprintf (stderr,                                            \
                     "ERROR " #CONTINUATION ": "                        \
                     #EXPRESSION " => {" __VA_ARGS__ "} "               \
                     #CONDITION "\n",                                   \
                     _RESULT);                                          \
            goto CONTINUATION;                                          \
        }                                                               \
        _RESULT;                                                        \
    })

#define TRACE(FORMAT, EXPRESSION)                               \
    ({                                                          \
        typeof(EXPRESSION) _VALUE = EXPRESSION;                 \
        fprintf (stderr,                                        \
                 "TRACE: " #EXPRESSION " => " FORMAT " \n",     \
                 _VALUE);                                       \
        _VALUE;                                                 \
    })

int main (int argc, char *argv[])
{
    int a = atoi(argv[1]);
    
    printf ("x: %d\n", IF(a, > 2, A_TOO_BIG, "%d"));
    printf ("y: %d\n", IF(a+1, > 2, A_PLUS_ONE_TOO_BIG, "%d"));

    return 0;
    
 A_TOO_BIG:
    return 1;

 A_PLUS_ONE_TOO_BIG:
    return 2;
}
