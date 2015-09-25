#include "xorshift.h"

uint32_t xorshift32 (uint32_t *x32)
{
  *x32 ^= *x32 << 13;
  *x32 ^= *x32 >> 17;
  *x32 ^= *x32 << 5;
  return *x32;
}
