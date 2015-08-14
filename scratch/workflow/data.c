#include "data.h"

#define DEFINE_PREDICATE(NAME, TYPE)    \
  int is_ ## NAME (value_t *value)      \
  {                                     \
    return value->type == TYPE ## _T;   \
  }                                     \

DEFINE_PREDICATE(exact, EXACT)
DEFINE_PREDICATE(inexact, INEXACT)
DEFINE_PREDICATE(symbol, SYMBOL)
DEFINE_PREDICATE(string, STRING)
DEFINE_PREDICATE(null, NULL)
DEFINE_PREDICATE(pair, PAIR)
