#include <syslog.h>
#include <error.h>

#include "logging.h"

__attribute__((constructor))
static void init_logging ()
{
  openlog (program_invocation_name (),
           LOG_NDELAY | LOG_PID,
           FACILITY);
}

__attribute__((destructor))
static void exit_logging () { closelog (); }
