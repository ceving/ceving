#include <stdint.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>

#include "errors.h"
#include "logging.h"
#include "result.h"

#include "copy.h"

#define BUFFER_SIZE 0x1000


result_t copy (int source, int destination)
{
  TRACE ("%d", source);
  TRACE ("%d", destination);

  result_t result = OK;

  uint8_t *buffer = malloc (BUFFER_SIZE);
  if (buffer == NULL) {
    result = ERRNO();
    FAIL (result, "Can not allocate memory for copy buffer.");
    goto RETURN;
  }

  ssize_t r, w;
  for (;;)
  {
    DEBUG ("start reading");
    r = read (source, buffer, BUFFER_SIZE);
    if (r < 0) {
      result = ERRNO();
      FAIL (result, "Can not read from file descriptor %d.", source);
      goto FREE_BUFFER;
    }
    if (r == 0) {
      break;
    }
    w = write (destination, buffer, r);
    if (w < 0) {
      result = ERRNO();
      FAIL (result, "Can not write to file descriptor %d.", destination);
      goto FREE_BUFFER;
    }
    if (r != w) {
      result = apperr(ERIO);
      FAIL (result, "Wrote only %d bytes of %d bytes read.", w, r);
      goto FREE_BUFFER;
    }
  }

FREE_BUFFER:
  free (buffer);

RETURN:
  return result;
}
