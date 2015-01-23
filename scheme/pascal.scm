;; A Pascal like while loop
(define-syntax while
  (syntax-rules ()
    ((while condition expression ...)
     (let ((thunk (lambda ()
                    expression
                    ...)))
       (let loop ()
         (if condition
             (begin
               (thunk)
               (loop))))))))
