;;
;; A Pascal like while loop
;;

(define-syntax while
  (syntax-rules ()
    ((while condition expression0 expression1 ...)
     (letrec ((loop (lambda ()
                      (when condition
                        expression0
                        expression1
                        ...
                        (loop)))))
       (loop)))))
