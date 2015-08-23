#include <stdlib.h>
#include <string.h>

#include "data.h"
#include "message.h"

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


value_t *make_atom (type_t type, size_t length, void *buffer)
{
  value_t *value = malloc (sizeof(*value));
  if (!value) {
    memory_error ("Can not allocate atom value");
    goto ERROR_VALUE;
  }

  atom_t *atom = malloc (sizeof(*atom));
  if (!atom) {
    memory_error ("Can not allocate atom");
    goto ERROR_ATOM;
  }

  void *new_buffer = malloc (length);
  if (!buffer) {
    memory_error ("Can not allocate atom buffer");
    goto ERROR_BUFFER;
  }

  memcpy (new_buffer, buffer, length);

  atom->length = length;
  atom->buffer = new_buffer;

  value->type = type;
  value->data.atom = atom;

  return value;

 ERROR_BUFFER:
  free (atom);

 ERROR_ATOM:
  free (value);

 ERROR_VALUE:
  return NULL;
}


value_t *make_pair (value_t *car, value_t *cdr)
{
  value_t *value = malloc (sizeof(*value));
  if (!value) {
    memory_error ("Can not allocate pair value");
    goto ERROR_VALUE;
  }

  pair_t *pair = malloc (sizeof(*pair));
  if (!pair) {
    memory_error ("Can not allocate pair");
    goto ERROR_PAIR;
  }

  pair->car = car;
  pair->cdr = cdr;

  value->type = PAIR_T;
  value->data.pair = pair;

  return value;

 ERROR_PAIR:
  free (value);

 ERROR_VALUE:
  return NULL;
}


value_t *make_atom_charp (type_t type, char *buffer)
{
  return make_atom (type, strlen (buffer), (void*) buffer);
}

