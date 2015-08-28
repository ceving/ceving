#include "global.h"

#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/file.h>

int action (char *filename, int input, int output)
{
  if (flock (input, LOCK_EX) < 0)
    ERROR_N (1, "Can not lock input.");
  if (flock (output, LOCK_EX) < 0)
    ERROR_N (2, "Can not lock output.");

  int pipe_in_fd[2];
  int pipe_out_fd[2];
  pid_t child_pid;

  if (pipe (pipe_in_fd) == -1)
    ERROR_N (5, "Can not create input pipe.");

  if (pipe (pipe_out_fd) == -1)
    ERROR_N (5, "Can not create output pipe.");

  child_pid = fork();
  if (child_pid == -1)
    ERROR_N (6, "Can not fork.");

  if (child_pid == 0)
    {
      int result;

      close (STDIN_FILENO);
      close (pipe_in_fd[1]);
      do {
        result = dup2 (pipe_in_fd[0], STDIN_FILENO);
        if (result < 0 && errno != EINTR)
          ERROR_N (7, "Can not duplicate stdin.");
      } while (result == EINTR);

      close (STDOUT_FILENO);
      close (pipe_out_fd[0]);
      do {
        result = dup2 (pipe_out_fd[1], STDOUT_FILENO);
        if (result < 0 && errno != EINTR)
          ERROR_N (8, "Can not duplicate stdout.");
      } while (result == EINTR);

      if (execl (filename, filename, (char*) NULL) < 0)
        ERROR_N (9, "Can not execute '%s'.", filename);

      exit (1);
    }
  else
    {
      close (pipe_in_fd[0]);
      close (pipe_out_fd[1]);

      copy (input, pipe_in_fd[1]);
      close (pipe_in_fd[1]);

      copy (pipe_out_fd[0], output);
      close (pipe_out_fd[0]);

      wait (0);
    }

  if (flock (output, LOCK_UN) < 0)
    ERROR_N (3, "Can not unlock output.");
  if (flock (input, LOCK_UN) < 0)
    ERROR_N (4, "Can not unlock input.");

  return 0;
}

int main (int argc, char *argv[])
{
  return action (argv[1], STDIN_FILENO, STDOUT_FILENO);
}
