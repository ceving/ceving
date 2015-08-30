#include "global.h"

#include <stdint.h>
#include <stdlib.h>
#include <error.h>
#include <errno.h>
#include <unistd.h>

#define BUFFER_SIZE 0x1000

int copy (int source, int destination)
{
  TRACE("%d", source);
  TRACE("%d", destination);

  /* Allocate memory for the copy buffer. */
  uint8_t *buffer = malloc (BUFFER_SIZE);
  if (buffer == NULL)
    LERROR (1, "Can not allocate %d bytes for the copy buffer.",
            BUFFER_SIZE);

  /* Read all input. */
  ssize_t r, w;
  for (;;) {
    r = read (source, buffer, BUFFER_SIZE);
    if (r < 0)
      LERROR (2, "Can not read from copy source (fd: %d).", source);
    if (r == 0) {
      break;
    }
    w = write (destination, buffer, r);
    if (w < 0)
      LERROR (3, "Can not write to copy destination (fd: %d).", destination);
    if (r != w)
      ERROR (4, "Wrote only %d bytes of %d bytes read.", w, r);
  }

  /* Free memory */
  free (buffer);

  return 0;
}

