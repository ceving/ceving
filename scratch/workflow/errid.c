#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <unistd.h>

__attribute__((constructor))
static void init_rand_with_pid() { srand(getpid()); }

typedef struct {
  unsigned int error     : 5;
  unsigned int sys_errno : 12;
  unsigned int id        : 15;
} result_t;

#define RESULT(error) (result_t) {error, errno, rand()}

result_t faulty ()
{
  return RESULT(1);
}

#define CASE(CLAUSE) case CLAUSE; break;

#define TRY(EXPRESSION, HANDLING) ({  \
  result_t result = EXPRESSION;       \
  switch (result.error) {             \
  case 0: break;                      \
  HANDLING                            \
  default: exit (1);                  \
  } })

#define presult(result)                                 \
  fprintf (stderr,                                      \
           "error: %d, errno: %d, id: %d\n",            \
           result.error, result.sys_errno, result.id)

int main (int argc, char *argv[])
{
  {
    result_t r = faulty();
    switch (r.error) {
    case 0: printf ("ok\n"); break;
    case 1: printf ("first error %d (errno: %d)\n", r.error, r.sys_errno); break;
    default: printf ("other error\n"); break;
    }
  }
  
  TRY(faulty(),
      CASE(1: presult (result))
      CASE(2: printf ("???\n")));

  printf ("%d\n", sizeof(result_t));
  
  return 0;
}
