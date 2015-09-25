#ifndef RESULT_H
#define RESULT_H

typedef struct {
  unsigned int id    : 16;  // random number identifying the error
  unsigned int sys   : 1;   // 1 for system, 0 for application errors
  unsigned int error : 15;  // either errno or application specific
} result_t;

uint32_t set_error_id (uint32_t new_error_id);
uint32_t get_error_id ();
uint32_t inc_error_id ();

#define OK      ((result_t) {0, 0, 0})
#define ERRNO() syserr(errno)

result_t syserr(int errnum);                  // system error
result_t apperr(int errnum);                  // application error
result_t conerr(result_t result, int errnum); // consequential error

#endif // RESULT_H
