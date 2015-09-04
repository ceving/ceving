#include "global.h"

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/file.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>


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
      DEBUG ("starting child");

      if (setpgrp() < 0)
        LERROR (10, "Can not set process group.");
      
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

      DEBUG ("terminating child");
      exit (1);
    }
  else
    {
      /* parent */
      DEBUG ("starting parent");
      
      TRACE("%d", close (parent_to_child[0]));
      TRACE("%d", close (child_to_parent[1]));

      copy (input, parent_to_child[1]);

      TRACE("%d", close (parent_to_child[1]));

      copy (child_to_parent[0], output);
      TRACE("%d", close (child_to_parent[0]));

      DEBUG ("waiting");
      wait (0);
      DEBUG ("terminating parent");
    }

  /*
  if (flock (output, LOCK_UN) < 0)
    LERROR (3, "Can not unlock output.");
  if (flock (input, LOCK_UN) < 0)
    LERROR (4, "Can not unlock input.");
  */

  return 0;
}

int open_input_state (char *filename)
{
  //  open (filename, O_RDONLY
  return 0;
}

int open_output_state (char *filename)
{
  int fd = open (".", O_TMPFILE | O_WRONLY, S_IRUSR | S_IWUSR);
  if (fd < 0)
    perror ("open");
  
  char message[] = "Hello World!";
  if (write (fd, message, sizeof(message)) < 0)
    perror ("write");

  if (linkat (fd, "", AT_FDCWD, "s1", AT_EMPTY_PATH) < 0)
    perror ("linkat");

  return -1;
}


int error_test()
{
  FAIL_IF((open("nix") < 0),
          "Can not open nix file.",
          
}




int main (int argc, char *argv[])
{
  //return action (argv[1], STDIN_FILENO, STDOUT_FILENO);
  TRACE("%d", open_output_state ("o1"));
  return 0;
}
