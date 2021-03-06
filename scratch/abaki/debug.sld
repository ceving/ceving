(define-library (debug)
  (export ?)
  (import (scheme base)
	  (scheme write))
  (begin
    (define-syntax ?
      (syntax-rules ()
	((? arg)
	 (let ((value arg))
	   (display ";; ")
	   (write (quote arg))
	   (display " -> ")
	   (write value)
	   (newline)
	   value))
	((? arg0 arg1 ...)
	 (begin 
	   (? arg0)
	   (? arg1 ...)
	   (if #f #t)))))))
