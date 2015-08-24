#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <error.h>
#include <stdarg.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <errno.h>


void info (const char* format, ...)
{
  va_list ap;
  va_start (ap, format);
  vprintf (format, ap);
  va_end (ap);
  printf ("\n");
}

int exec (char *filename)
{
  pid_t pid = fork();

  if (pid < 0) {
    perror ("Can not fork.");
    return -1;
  }

  if (pid > 0) {
    info ("Executed: %d", pid);
    return pid;
  }

  execl (filename, filename, (char*) NULL);
  perror ("execl");
  return -1;
}


int make_state ()
{
  
}

int main (int argc, char *argv[])
{
  exec ("./one");

  while (wait (NULL))
    if (errno == ECHILD)
      break;

  return 0;
}
