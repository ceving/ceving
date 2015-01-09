(import (scheme write))

(define-syntax ?
  (syntax-rules ()
    ((? tag arg)
     (let ((p (current-error-port)))
       (let ((value arg))
         (display ";" p)
         (if tag
             (begin
               (display #\space p)
               (display tag p)
               (display #\: p)))
         (display #\space p)
         (write (quote arg) p)
         (display " => " p)
         (write value p)
         (newline p)
         value)))
    ((? arg)
     (? #f arg))))
