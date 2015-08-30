#ifndef MESSAGE_H
#define MESSAGE_H

#include <stddef.h>
#include <syslog.h>

char *logging_priority_abbreviation (int priority);

int log_message (char *buffer,
                 size_t length,
                 int priority,
                 char *file,
                 int line,
                 char *format,
                 ...);

#endif /* MESSAGE_H */
