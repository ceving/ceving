#include <sys/types.h>
#include <unistd.h>
#include <signal.h>

int main (int argc, char *argv[])
{
  kill (getpid (), SIGKILL);
  return -1;
}
