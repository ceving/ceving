;; A Pascal like while loop
(define-syntax while
  (syntax-rules ()
    ((while condition expression ...)
     (let ((thunk (lambda ()
                    expression
                    ...)))
       (let loop ()
         (when condition
           (thunk)
           (loop)))))))
