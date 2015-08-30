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
  /*
  if (flock (input, LOCK_EX) < 0)
    LERROR (1, "Can not lock input.");
  if (flock (output, LOCK_EX) < 0)
    LERROR (2, "Can not lock output.");
  */

  int parent_to_child[2];
  int child_to_parent[2];
  pid_t child_pid;

  if (pipe (parent_to_child) == -1)
    LERROR (5, "Can not create parent to child pipe.");

  TRACE("%d", parent_to_child[1]);
  TRACE("%d", parent_to_child[0]);

  if (pipe (child_to_parent) == -1)
    LERROR (5, "Can not create output pipe.");

  TRACE("%d", child_to_parent[1]);
  TRACE("%d", child_to_parent[0]);

  child_pid = fork();
  if (child_pid == -1)
    LERROR (6, "Can not fork.");


  if (child_pid == 0)
    {
      /* child */
      int result;

      close (parent_to_child[1]);
      close (child_to_parent[0]);

      do {
        result = dup2 (parent_to_child[0], STDIN_FILENO);
        if (result < 0 && errno != EINTR)
          LERROR (7, "Can not duplicate stdin.");
      } while (result == EINTR);

      do {
        result = dup2 (child_to_parent[1], STDOUT_FILENO);
        if (result < 0 && errno != EINTR)
          LERROR (8, "Can not duplicate stdout.");
      } while (result == EINTR);

      close (parent_to_child[0]);
      close (child_to_parent[1]);

      if (execl (filename, filename, (char*) NULL) < 0)
        LERROR (9, "Can not execute '%s'.", filename);

      exit (1);
    }
  else
    {
      /* parent */
      close (parent_to_child[0]);
      close (child_to_parent[1]);

      copy (input, parent_to_child[1]);

      close (parent_to_child[1]);


      copy (child_to_parent[0], output);
      close (child_to_parent[0]);

      wait (0);
    }

  /*
  if (flock (output, LOCK_UN) < 0)
    LERROR (3, "Can not unlock output.");
  if (flock (input, LOCK_UN) < 0)
    LERROR (4, "Can not unlock input.");
  */
  return 0;
}

int main (int argc, char *argv[])
{
  WARN("warn");
  INFO("info");
  NOTICE("notice");
  return action (argv[1], STDIN_FILENO, STDOUT_FILENO);
}
