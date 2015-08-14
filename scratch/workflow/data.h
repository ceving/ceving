#ifndef DATA_H
#define DATA_H

#include <stddef.h>

typedef enum {
  EXACT_T,
  INEXACT_T,
  SYMBOL_T,
  STRING_T,
  NULL_T,
  PAIR_T,
} type_t;

typedef struct value_s value_t;
typedef struct atom_s atom_t;
typedef struct pair_s pair_t;
typedef struct list_s list_t;

struct value_s {
  type_t type;
  union {
    atom_t *exact, *inexact, *symbol, *string;
    pair_t *pair;
  } value;
};

struct atom_s {
  size_t length;
  void *buffer;
};
  
struct pair_s {
  value_t *car;
  value_t *cdr;
};

#define DECLARE_PREDICATE(NAME) int is_ ## NAME (value_t *value);

DECLARE_PREDICATE(exact)
DECLARE_PREDICATE(inexact)
DECLARE_PREDICATE(symbol)
DECLARE_PREDICATE(string)
DECLARE_PREDICATE(null)
DECLARE_PREDICATE(pair)

#endif /* DATA_H */
