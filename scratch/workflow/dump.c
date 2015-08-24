#include <stdio.h>
#include <stdlib.h>

int main (int argc, char *argv[], char *envp[])
{
  int j;

  for (j = 0; argv[j] != NULL; j++)
    printf("argv[%d]: %s\n", j, argv[j]);

  for (j = 0; envp[j] != NULL; j++)
    printf("envp[%d]: %s\n", j, envp[j]);

  exit (EXIT_SUCCESS);
}
