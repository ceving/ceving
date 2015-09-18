#Include <stdint.h>
#include <stdlib.h>
#include <error.h>
#include <errno.h>
#include <unistd.h>

#include "errors.h"

#include "copy.h"

#define BUFFER_SIZE 0x1000


int copy (int source, int destination)
{
  ERRORS (OUT_OF_MEMORY,
          CAN_NOT_READ,
          CAN_NOT_WRITE,
          WRITE_INCOMPLETE);

  TRACEd (source);
  TRACEd (destination);

  int result = 0;

  uint8_t *buffer = malloc (BUFFER_SIZE);
  IF_NULL (buffer, OUT_OF_MEMORY);

  ssize_t r, w;
  for (;;)
  {
    DEBUG ("start reading");
    r = read (source, buffer, BUFFER_SIZE);
    IF_ERRNO (r, CAN_NOT_READ);
    if (r == 0) {
      break;
    }
    w = write (destination, buffer, r);
    IF_ERRNO(w, CAN_NOT_WRITE);
    if (r != w) {
      TRACEd(r);
      TRACEd(w);
            
      ERROR (4, "Wrote only %d bytes of %d bytes read.", w, r);
    }
  }
    
CAN_NOT_READ:
CAN_NOT_WRITE:
WRITE_INCOMPLETE:
    
  free (buffer);
            
OUT_OF_MEMORY:

  RETURN ();
}
