#include <errno.h>
#include <sys/types.h>
#include <unistd.h>
#include <time.h>

#include "xorshift.h"

#include "result.h"

//
// Static initialization of the error identifier.
//
static uint32_t error_id = 314159265;

//
// Dynamic initializiation of the error identifier.
//
__attribute__((constructor))
static void init_error_id() { set_error_id (getpid() * time()); }

//
// Sets a new error identifier.  The new error identifier must not be
// null.
//
uint32_t set_error_id (uint32_t new_error_id)
{
  if (new_error_id)
    error_id = new_error_id;
  return error_id;
}

//
// Returns the current error identifier without generating a new one.
//
uint32_t get_error_id ()
{
  return error_id;
}

//
// Generate a new error identifier.
//
uint32_t new_error_id ()
{
  return xorshift32 (&error_id);
}

//
// Create a new system error.
//
result_t syserr(int errnum)
{
  return (result_t) {inc_error_id(), 1, errnum};
}

//
// Create a new application error.
//
result_t apperr(int errnum)
{
  return (result_t) {inc_error_id(), 0, errnum};
}

//
// Create a consequential error.  A consequential error inherits the
// error identifier from an existing error and is always an
// application error.
//
result_t conerr(result_t result, int errnum)
{
  return (result_t) {result.id, 0, errnum};
}

