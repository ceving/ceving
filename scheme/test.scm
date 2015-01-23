;;
;; Testing
;;

(define-syntax test
  (syntax-rules ()
    ((test function index (predicate (argument ...) result))
     (let ((value (function argument ...)))
       (let ((test-result (predicate value result)))
         (display 'function)
         (if index
             (begin
               (display " ")
               (display index)))
         (display ": ")
         (if test-result
             (display "ok")
             (begin
               (display "FAILURE")
               (newline)
               (display "  Expression: ")
               (write '(function argument ...))
               (newline)
               (display "  returns: ")
               (display value)
               (newline)
               (display "  expecting: ")
               (write result)))
         (newline)
         test-result)))
    ((test function index ((argument ...) result))
     (test function index (equal? (argument ...) result)))
    ((test function (predicate (argument ...) result))
     (test function #f (predicate (argument ...) result)))
    ((test function ((argument ...) result))
     (test function #f (equal? (argument ...) result)))))

(define-syntax test*
  (syntax-rules ()
    ((test* function definition ...)
     (let ((counter (let ((value 1))
                      (lambda ()
                        (let ((this value))
                          (set! value (+ value 1))
                          this)))))
       (and (let ((index (counter)))
              (test function index definition))
            ...)))))
