#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdint.h>
#include <error.h>
#include <errno.h>
#include <limits.h>
#include <math.h>

#define BUFFER_SIZE 0x1000

int main (int argc, char *argv[])
{
  int buffer_size = BUFFER_SIZE;
  int process_id = 0;
  int task_id = 0;

  /* Parse command line options. */
  int opt;
  while ((opt = getopt(argc, argv, "p:t:b:")) != -1) {
    switch (opt) {
    case 'p':
      process_id = atoi (optarg);
      if (process_id <= 0)
        error (EXIT_FAILURE, 0, "Invalid process id.");
      break;
    case 't':
      task_id = atoi (optarg);
      if (task_id <= 0)
        error (EXIT_FAILURE, 0, "Invalid task id.");
      break;
    case 'b':
      buffer_size = atoi (optarg);
      break;
    default:
      error (EXIT_FAILURE, 0,
             "Usage: state -p process_id -t task_id -b buffer_size.");
    }
  }

  /* Check parameters. */
  if (process_id <= 0)
    error (EXIT_FAILURE, 0, "Process id undefined.");
  if (task_id <= 0)
    error (EXIT_FAILURE, 0, "Task id undefined.");
  
  /* Allocate memory for the copy buffer. */
  uint8_t *buffer = malloc (buffer_size);
  if (buffer == NULL)
    error (EXIT_FAILURE, errno,
           "Can not allocate %d bytes for the copy buffer.", buffer_size);

  /* Allocate memory for the state file name. */
  int int_length = floor (log10 (INT_MAX)) + 1;
  int max_filename = int_length * 2 + 7 + 1; /* must match the pattern in snprintf. */
  char *filename = malloc (max_filename);
  if (filename == NULL)
    error (EXIT_FAILURE, errno,
           "Can not allocate memory for state file name.");
  snprintf (filename, max_filename, "%d-%d.state", process_id, task_id);

  /* Open the file for the state data. */
  int state_fd = creat (filename, S_IRUSR | S_IWUSR);
  if (state_fd < 0)
    error (EXIT_FAILURE, errno,
           "Can not open state file '#%s' for writing.", filename);

  /* Read all input. */
  ssize_t r, w;
  for (;;) {
    r = read (STDIN_FILENO, buffer, buffer_size);
    if (r < 0)
      error (EXIT_FAILURE, errno,
             "Can not read state data.");
    if (r == 0) {
      break;
    }
    w = write (state_fd, buffer, r);
    if (w < 0)
      error (EXIT_FAILURE, errno,
             "Can not write state data.");
    if (r != w)
      error (EXIT_FAILURE, 0,
             "Wrote only %d bytes of %d bytes read.", w, r);
  }

  /* Sync file system. */
  if (fsync (state_fd) < 0)
    error (EXIT_FAILURE, errno, "Can not sync file.");
  int dir_fd = open (".", O_DIRECTORY|O_RDONLY);
  if (dir_fd < 0)
    error (EXIT_FAILURE, errno, "Can not open directory.");
  if (fsync (dir_fd) < 0)
    error (EXIT_FAILURE, errno, "Can not sync directory.");

  return 0;
}
