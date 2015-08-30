#include <errno.h>
#include <error.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <syslog.h>
#include <time.h>
#include <unistd.h>

extern char *program_invocation_short_name;

/*
  Use the following compilation buffer configuration to get the
  colors and hyperlinks right.

  (add-to-list 'compilation-error-regexp-alist 'my-message)
  (add-to-list 'compilation-error-regexp-alist-alist
    '(my-message
      "^\\(\\(ERRR\\|CRIT\\|ALRT\\|EMRG\\)\\|\\(WARN\\|NTCE\\)\\|\\(INFO\\|DEBG\\)\\) .*\\[\\(\\([^ \n]+\\):\\([0-9]+\\)\\)\\]$"
      6 7 nil (3 . 4) 5))
*/

char *logging_priority_abbreviation (int priority)
{
  switch (priority) {
  case LOG_DEBUG:   return "DEBG";
  case LOG_INFO:    return "INFO";
  case LOG_NOTICE:  return "NTCE";
  case LOG_WARNING: return "WARN";
  case LOG_ERR:     return "ERRR";
  case LOG_CRIT:    return "CRIT";
  case LOG_ALERT:   return "ALRT";
  case LOG_EMERG:   return "EMRG";
  }
  return "UNKN";
}

int log_message (char *buffer,
                 size_t length,
                 int priority,
                 char *file,
                 int line,
                 char *format,
                 ...)
{
  size_t used = 0;

  /* priority */
  int i = snprintf (&buffer[used], length - used,
                    logging_priority_abbreviation(priority));
  if (i < 0)
    return -1;
  used += i;

  /* time stamp */
  time_t t = time (NULL);
  struct tm *lt = localtime (&t);
  size_t s = strftime (&buffer[used], length - used,
                       " %Y-%m-%d %H:%M:%S %z ", lt);
  if (s == 0)
    return -2;
  used += s;

  /* hostname */
  i = gethostname (&buffer[used], length - used);
  if (i < 0)
    return -3;
  while (buffer[used] != '\0') used++;

  /* program name and process identifier */
  i = snprintf (&buffer[used], length - used,
                " %s[%ld]: ",
                program_invocation_short_name,
#ifdef SYS_gettid
                syscall(SYS_gettid)
#else
                getpid()
#endif
                );
  if (i < 0)
    return -4;
  used += i;

  /* message */
  va_list ap;
  va_start (ap, format);
  i = vsnprintf (&buffer[used], length - used, format, ap);
  va_end (ap);
  if (i < 0)
    return -5;
  used += i;

  /* file name and line number */
  i = snprintf (&buffer[used], length - used,
                " [%s:%d]", file, line);
  if (i < 0)
    return -6;
  used += i;

  return used;
}
